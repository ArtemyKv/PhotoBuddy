//
//  DetailInfoViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 17.11.2022.
//

import Foundation
import UIKit.UIImage

class PhotoDetailsViewModel {
    static let addToFavoritesNotification = Notification.Name("PhotoDetailsViewModel.addToFavorites")
    static let removeFromFavoritesNotification = Notification.Name("PhotoDetailsViewModel.removeFromFavorites")
    
    //View model properties
    private var photoFetchingManager = PhotoFetchingManager.shared
    private var managedContext = CoreDataStack.shared.managedContext
    private var isInitialyInfavorites = false
    private var cachedBriefPhotoInfo: CachedBriefPhotoInfo?
    private var briefPhotoInfo: BriefPhotoInfo
    private var photo: UIImage? {
        didSet {
            guard let photo = photo else { return }
            self.image.value = photo
        }
    }
    
    let photoInfoViewModel = PhotoInfoViewModel()
    weak var alertPresenter: AlertPresenter?
    
    //View properties
    var image: Box<UIImage?> = Box(value: nil)
    var isInFavorites = Box<Bool>(value: false)
    
    init(briefPhotoInfo: BriefPhotoInfo) {
        self.briefPhotoInfo = briefPhotoInfo
        checkPhotoInitialFavoritesStatus()
    }
    
    private func checkPhotoInitialFavoritesStatus() {
        let fetchRequest = CachedBriefPhotoInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CachedBriefPhotoInfo.photoID), briefPhotoInfo.id)
        if let cachedPhotoInfos = try? managedContext.fetch(fetchRequest), !cachedPhotoInfos.isEmpty {
            cachedBriefPhotoInfo = cachedPhotoInfos.first
            isInFavorites.value = true
            isInitialyInfavorites = true
        } else {
            isInFavorites.value = false
            isInitialyInfavorites = false
        }
    }
    
    private func createCachedInfo() {
        let cachedInfo = CachedBriefPhotoInfo(context: managedContext)
        cachedInfo.photoID = briefPhotoInfo.id
        cachedInfo.authorName = briefPhotoInfo.authorName
        cachedInfo.url = briefPhotoInfo.url
        cachedInfo.blurHash = briefPhotoInfo.blurHash
        cachedInfo.addToFavoritesDate = Date()
    }
    
    private func saveToFavorites() {
        guard !isInitialyInfavorites && isInFavorites.value == true else { return }
        createCachedInfo()
        try? managedContext.save()
        NotificationCenter.default.post(
            name: PhotoDetailsViewModel.addToFavoritesNotification,
            object: nil,
            userInfo: ["photoInfo": briefPhotoInfo])
    }
    
    private func removeFromFavorites() {
        guard let cachedBriefPhotoInfo = cachedBriefPhotoInfo else { return }
        managedContext.delete(cachedBriefPhotoInfo)
        try? managedContext.save()
        NotificationCenter.default.post(
            name: PhotoDetailsViewModel.removeFromFavoritesNotification,
            object: nil,
            userInfo: ["photoInfo": briefPhotoInfo])
    }
    
    func updateFavorites() {
        if isInFavorites.value {
            saveToFavorites()
        } else {
            removeFromFavorites()
        }
    }
    
    func fetchDetailPhotoInfo(completion: @escaping () -> (Void)) {
        photoFetchingManager.fetchDetailPhotoInfo(photoID: briefPhotoInfo.id) { [weak self] info, error in
            if let error = error {
                self?.alertPresenter?.presentErrorAlert(title: "Error", message: error.description)
                completion()
                return
            }
            
            guard let info = info else { return }
            
            self?.photoInfoViewModel.detailPhotoInfo = info
            self?.photoFetchingManager.downloadPhoto(url: info.photoURL, completion: { photo in
                self?.photo = photo
                completion()
            })
        }
    }
    
}
