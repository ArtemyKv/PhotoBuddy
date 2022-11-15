//
//  DetailPhotoInfo.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

struct DetailPhotoInfo: Codable {
    var id: String
    var creationDate: Date
    var downloads: Int
    var description: String
    var location: Location
    var authorName: String
    var photoURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate = "created_at"
        case downloads
        case description
        case location
        case authorName = "user"
        case photoURL = "urls"
        
        enum UserKeys: String, CodingKey {
            case name
        }
        
        enum ImageURLKeys: String, CodingKey {
            case full
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.downloads = try container.decode(Int.self, forKey: .downloads)
        self.description = try container.decode(String.self, forKey: .description)
        self.location = try container.decode(Location.self, forKey: .location)
        let authorNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.UserKeys.self, forKey: .authorName)
        let imageURLNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageURLKeys.self, forKey: .photoURL)
        self.authorName = try authorNestedContainer.decode(String.self, forKey: .name)
        self.photoURL = try imageURLNestedContainer.decode(URL.self, forKey: .full)
    }
}
