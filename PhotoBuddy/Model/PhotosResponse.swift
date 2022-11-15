//
//  PhotosResponse.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

struct PhotosResponse: Codable {
    var total: Int
    var totalPages: Int
    var photoInfos: [BriefPhotoInfo]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case photoInfos = "results"
    }
}
