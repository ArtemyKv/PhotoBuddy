//
//  DetailInfoViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 17.11.2022.
//

import Foundation
import UIKit.UIImage

class PhotoDetailsViewModel {
    //View model properties
    private var photoFetchingManager: PhotoFetchingManager
    private var photoID: String
    private var blurHash: String
    private var photo: UIImage? {
        didSet {
            guard let photo = photo else { return }
            self.image.value = photo
        }
    }
    
    let photoInfoViewModel = PhotoInfoViewModel()
    
    //View properties
    var image: Box<UIImage?> = Box(value: nil)
    var authorName = Box(value: "")
    var location = Box(value: "")
    var downloads = Box(value: "")
    
    init(photoID: String, blurHash: String, photoFetchingManager: PhotoFetchingManager) {
        self.photoID = photoID
        self.blurHash = blurHash
        self.photoFetchingManager = photoFetchingManager
    }
    
    func fetchDetailPhotoInfo() {
        photoFetchingManager.fetchDetailPhotoInfo(photoID: photoID) { [weak self] info, error in
            guard let info = info else {
                //TODO: - present alert with error
                return
            }
            self?.photoInfoViewModel.detailPhotoInfo = info
            self?.photoFetchingManager.downloadPhoto(url: info.photoURL, completion: { photo in
                self?.photo = photo
            })
        }
    }
    
}
