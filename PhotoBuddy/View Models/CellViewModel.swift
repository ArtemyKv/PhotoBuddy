//
//  CellViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation
import UIKit.UIImage

class CellViewModel {
    var photoFetchingManager = PhotoFetchingManager.shared
    
    var photoInfo: BriefPhotoInfo
    
    var photo: Box<UIImage?> = Box(value: nil)
    var authorName = Box(value: "")
    var creatinDate = Box(value: "")
    
    init(photoInfo: BriefPhotoInfo) {
        self.photoInfo = photoInfo
        configure()
        fetchImage()
    }

    func configure() {
        self.photo.value = UIImage(blurHash: photoInfo.blurHash, size: CGSize(width: 32, height: 32))
        self.authorName.value = photoInfo.authorName
    }
    
    private func fetchImage() {
        photoFetchingManager.downloadPhoto(url: photoInfo.url) { [weak self] image in
            self?.photo.value = image
        }
    }
}

extension CellViewModel: Hashable {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        return lhs.photoInfo == rhs.photoInfo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoInfo.id)
    }
}
