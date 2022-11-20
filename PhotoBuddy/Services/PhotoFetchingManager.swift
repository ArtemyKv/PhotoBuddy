//
//  PhotoFetchingManager.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 11.11.2022.
//

import Foundation
import UIKit.UIImage

enum PhotosFetchingError: Error {
    case failedRequest
    case invalidResponse
    case noData
    case invalidData
}

class PhotoFetchingManager {
    
    private let apiKey = "2C_Da4yPnD49J4lllIVkiSZEY3Dct6nuz0ldMSjIivI"
    private let scheme = "https"
    private let host = "api.unsplash.com"
    
    private enum Endpoint: String {
        case search = "/search/photos"
        case randomPhotos = "/photos/random"
        case photoDetail = "/photos"
    }
    
    private var semaphore = DispatchSemaphore(value: 10)
    private var imageDownloadingTasks: [URL: URLSessionDataTask] = [:]
    private var cachedImages = NSCache<NSString, UIImage>()
    
    private func cachedImage(for urlString: NSString) -> UIImage? {
        return cachedImages.object(forKey: urlString)
    }
    
    private func urlRequest(endpoint: Endpoint, queries: [String: String], photoID: String? = nil) -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = endpoint.rawValue
        if photoID != nil {
            components.path += "/\(photoID!)"
        }
        components.queryItems = queries.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
    
    func fetchSearchPhotoInfo(searchTerm: String, page: Int = 1, completion: @escaping (PhotosResponse?, PhotosFetchingError?) -> (Void) ) {
        imageDownloadingTasks = [:]
        
        let queriesDict = [
            "client_id": "\(apiKey)",
            "query": "\(searchTerm)",
            "page": "\(page)",
            "per_page": "30"
        ]
        let request = urlRequest(endpoint: Endpoint.search, queries: queriesDict)
        self.fetchPhotoInfo(request: request, completion: completion)
    }
    
    func fetchDetailPhotoInfo(photoID: String, completion: @escaping (DetailPhotoInfo?, PhotosFetchingError?) -> (Void)) {
        let queriesDict = [
            "client_id": "\(apiKey)"
        ]
        let request = urlRequest(endpoint: .photoDetail, queries: queriesDict, photoID: photoID)
        self.fetchPhotoInfo(request: request, completion: completion)
    }
    
    func fetchPhotoInfo<T: Codable>(request: URLRequest, completion: @escaping (T?, PhotosFetchingError?) -> (Void) ) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("failedRequest. Error: \(error!), \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("Failure response with code: \(httpResponse.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from server")
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedInfo = try decoder.decode(T.self, from: data)
                    completion(decodedInfo, nil)
                } catch {
                    print("Invalid data")
                    completion(nil, .invalidData)
                }
            }
        }
        task.resume()
    }
    
    func downloadPhoto(url: URL, completion: @escaping (UIImage?) -> (Void)) {
        let cacheID = NSString(string: url.absoluteString)
        if let cachedImage = cachedImage(for: cacheID) {
            completion(cachedImage)
            return
        }
        let request = URLRequest(url: url)
        imageDownloadingTasks[url] = nil
        imageDownloadingTasks[url] = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.semaphore.wait()
            defer {
                self?.imageDownloadingTasks[url] = nil
                self?.semaphore.signal()
                print("deffered!")
            }
            
            guard error == nil else {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self?.cachedImages.setObject(image, forKey: cacheID)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        imageDownloadingTasks[url]!.resume()
    }
}
