//
//  CellViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation
import UIKit.UIImage

protocol CellViewModelProtocol: AnyObject {
    init(photoInfo: BriefPhotoInfo)
    
    typealias PhotoBinding = (UIImage?) -> Void
    typealias StringBinding = (String) -> Void
    
    func bindPhoto(_ binding: PhotoBinding?)
    func bindAuthorName(_ binding: StringBinding?)
    func removeBindings()
    
}

final class CellViewModel: CellViewModelProtocol {
    private var photoFetchingManager = PhotoFetchingManager.shared
    
    private var photoInfo: BriefPhotoInfo
    
    private var photo: Box<UIImage?> = Box(value: nil)
    private var authorName = Box(value: "")
    private var creatinDate = Box(value: "")
    
    init(photoInfo: BriefPhotoInfo) {
        self.photoInfo = photoInfo
        configure()
        fetchImage()
    }

    private func configure() {
        if let blurHash = photoInfo.blurHash {
            self.photo.value = UIImage(blurHash: blurHash, size: CGSize(width: 32, height: 32))
        } else {
            self.photo.value = UIImage(systemName: "exclamationmark.triangle")
        }
        self.authorName.value = photoInfo.authorName
    }
    
    private func fetchImage() {
        photoFetchingManager.downloadPhoto(url: photoInfo.url) { [weak self] image in
            self?.photo.value = image
        }
    }
    
    func bindPhoto(_ binding: PhotoBinding?) {
        photo.bind(listener: binding)
    }
    
    func bindAuthorName(_ binding: StringBinding?) {
        authorName.bind(listener: binding)
    }
    
    func removeBindings() {
        photo.listener = nil
        authorName.listener = nil
        creatinDate.listener = nil
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
