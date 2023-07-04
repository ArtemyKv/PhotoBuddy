//
//  PhotoInfo.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

struct BriefPhotoInfo: Codable {
    var id: String
    var width: Int
    var height: Int
    var blurHash: String?
    var url: URL
    var authorName: String
    
    enum CodingKeys: String ,CodingKey {
        case id
        case width
        case height
        case blurHash = "blur_hash"
        case url = "urls"
        case authorName = "user"
        
        enum URLCodingKeys: String, CodingKey {
            case url = "small"
        }
        
        enum UserCodingKeys: String, CodingKey {
            case name
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.blurHash = try container.decode(String?.self, forKey: .blurHash)
        let urlNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.URLCodingKeys.self, forKey: .url)
        self.url = try urlNestedContainer.decode(URL.self, forKey: .url)
        let userNestedContainer = try container.nestedContainer(keyedBy: CodingKeys.UserCodingKeys.self, forKey: .authorName)
        self.authorName = try userNestedContainer.decode(String.self, forKey: .name)
    }
    
    init(id: String, width: Int, height: Int, blurHash: String, url: URL, authorName: String) {
        self.id = id
        self.width = width
        self.height = height
        self.blurHash = blurHash
        self.url = url
        self.authorName = authorName
    }
}

extension BriefPhotoInfo: Equatable {
    static func == (lhs: BriefPhotoInfo, rhs: BriefPhotoInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
