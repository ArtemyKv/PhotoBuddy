//
//  PhotoInfo.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

struct BriefPhotoInfo: Codable {
    var id: String
    var blurHash: String
    var url: URL
    var authorName: String
    
    enum CodingKeys: String ,CodingKey {
        case id
        case blurHash = "blur_hash"
        case url = "urls"
        case authorName = "user"
        
        enum URLCodingKeys: String, CodingKey {
            case url = "thumb"
        }
        
        enum UserCodingKeys: String, CodingKey {
            case name
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.blurHash = try container.decode(String.self, forKey: .blurHash)
        let urlNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.URLCodingKeys.self, forKey: .url)
        self.url = try urlNestedContainer.decode(URL.self, forKey: .url)
        let userNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.UserCodingKeys.self, forKey: .authorName)
        self.authorName = try userNestedContainer.decode(String.self, forKey: .name)
    }
}

extension BriefPhotoInfo: Equatable {
    static func == (lhs: BriefPhotoInfo, rhs: BriefPhotoInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
