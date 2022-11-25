//
//  CachedBriefPhotoInfo+CoreDataProperties.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 24.11.2022.
//
//

import Foundation
import CoreData


extension CachedBriefPhotoInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedBriefPhotoInfo> {
        return NSFetchRequest<CachedBriefPhotoInfo>(entityName: "CachedBriefPhotoInfo")
    }

    @NSManaged public var addToFavoritesDate: Date?
    @NSManaged public var authorName: String?
    @NSManaged public var blurHash: String?
    @NSManaged public var photoID: String?
    @NSManaged public var url: URL?

}

extension CachedBriefPhotoInfo : Identifiable {

}
