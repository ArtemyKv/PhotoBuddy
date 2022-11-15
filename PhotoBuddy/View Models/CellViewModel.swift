//
//  CellViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation
import UIKit.UIImage

class CellViewModel {
    var photoInfo: BriefPhotoInfo
    
    var photo: Box<UIImage?> = Box(value: nil)
    
    init(photoInfo: BriefPhotoInfo) {
        self.photoInfo = photoInfo
        configure()
    }

    
    
    func configure() {
        self.photo.value = UIImage(blurHash: photoInfo.blurHash, size: CGSize(width: 32, height: 32))
    }
    
    func fetchImage(fetchingManager: PhotoFetchingManager) {
        fetchingManager.downloadPhoto(url: photoInfo.url) { [weak self] image in
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
