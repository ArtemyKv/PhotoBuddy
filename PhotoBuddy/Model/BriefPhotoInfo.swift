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
    
    enum CodingKeys: String ,CodingKey {
        case id
        case blurHash = "blur_hash"
        case url = "urls"
        
        enum URLCodingKeys: String, CodingKey {
            case url = "thumb"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.blurHash = try container.decode(String.self, forKey: .blurHash)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.URLCodingKeys.self, forKey: .url)
        self.url = try nestedContainer.decode(URL.self, forKey: .url)
    }
}

extension BriefPhotoInfo: Equatable {
    static func == (lhs: BriefPhotoInfo, rhs: BriefPhotoInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
