//
//  DetailInfoViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 17.11.2022.
//

import Foundation
import UIKit.UIImage

protocol PhotoDetailsViewModelProtocol: AnyObject {
    
    typealias PhotoBinding = (UIImage?) -> Void
    typealias IsInFavotitesBinding = (Bool) -> Void
    typealias AuthorNameBinding = (String) -> Void
    typealias isLoadingBinding = (Bool) -> Void
    typealias AlertViewModelBinding = (AlertViewModel?) -> Void
    
    func bindPhoto(_ binding: PhotoBinding?)
    func bindIsInFavorites(_ binding: IsInFavotitesBinding?)
    func bindAuthorName(_ binding: AuthorNameBinding?)
    func bindIsLoading(_ binding: isLoadingBinding?)
    func bindAlertViewModel(_ binding: AlertViewModelBinding?)
    
    func viewDidLoad()
    func viewWillDisappear()
    func toggleFavoritesButtonPressed()
    func getPhoto() -> UIImage?
}
    
class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    
    static let addToFavoritesNotification = Notification.Name("PhotoDetailsViewModel.addToFavorites")
    static let removeFromFavoritesNotification = Notification.Name("PhotoDetailsViewModel.removeFromFavorites")
    
    //View model properties
    private var photoFetchingManager = PhotoFetchingManager.shared
    private var managedContext = CoreDataStack.shared.managedContext
    private var cachedBriefPhotoInfo: CachedBriefPhotoInfo?
    private var briefPhotoInfo: BriefPhotoInfo
    private var isInitialyInFavorites = false
    
    let photoInfoViewModel = PhotoInfoViewModel()
    
    //View properties
    private var photo: Box<UIImage?> = Box(value: nil)
    private var isInFavorites = Box<Bool>(value: false)
    private var authorName = Box(value: "")
    private var isLoading = Box(value: false)
    private var alertViewModel: Box<AlertViewModel?> = Box(value: nil)
    
    init(briefPhotoInfo: BriefPhotoInfo) {
        self.briefPhotoInfo = briefPhotoInfo
        self.authorName.value = briefPhotoInfo.authorName
        checkInitialFavoritesStatus()
    }
    
    private func checkInitialFavoritesStatus() {
        let fetchRequest = CachedBriefPhotoInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CachedBriefPhotoInfo.photoID), briefPhotoInfo.id)
        if let cachedPhotoInfos = try? managedContext.fetch(fetchRequest), !cachedPhotoInfos.isEmpty {
            cachedBriefPhotoInfo = cachedPhotoInfos.first
            isInFavorites.value = true
            isInitialyInFavorites = true
        } else {
            isInFavorites.value = false
            isInitialyInFavorites = false
        }
    }
    
    private func makeCachedInfo() {
        let cachedInfo = CachedBriefPhotoInfo(context: managedContext)
        cachedInfo.photoID = briefPhotoInfo.id
        cachedInfo.authorName = briefPhotoInfo.authorName
        cachedInfo.url = briefPhotoInfo.url
        cachedInfo.blurHash = briefPhotoInfo.blurHash
        cachedInfo.addToFavoritesDate = Date()
    }
    
    private func addToFavorites() {
        guard !isInitialyInFavorites && isInFavorites.value == true else { return }
        makeCachedInfo()
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
    
    private func loadPhotoDetails(completion: @escaping () -> Void) {
        photoFetchingManager.fetchDetailPhotoInfo(photoID: briefPhotoInfo.id) { [weak self] info, error in
            if let error = error {
                self?.setAlertWith(title: "Error", message: error.description)
                completion()
                return
            }
            guard let info = info else {
                completion()
                return
            }
            self?.photoInfoViewModel.detailPhotoInfo = info
            self?.photoFetchingManager.downloadPhoto(url: info.photoURL, completion: { photo in
                self?.photo.value = photo
                completion()
            })
        }
    }
    
    private func setAlertWith(title: String?, message: String?) {
        if let title, let message {
            self.alertViewModel.value = AlertViewModel(title: title, message: message)
        } else {
            self.alertViewModel.value = nil
        }
    }
    
    
    //MARK: - Inputs
    
    func viewDidLoad() {
        self.isLoading.value = true
        loadPhotoDetails(completion: { [weak self] in
            self?.isLoading.value = false
        })
    }
    
    func viewWillDisappear() {
        if isInFavorites.value {
            addToFavorites()
        } else {
            removeFromFavorites()
        }
    }
    
    func toggleFavoritesButtonPressed() {
        isInFavorites.value.toggle()
    }
    
    func getPhoto() -> UIImage? {
        return photo.value
    }
    
    //MARK: - Bindings
    func bindPhoto(_ binding: PhotoBinding?) {
        photo.bind(listener: binding)
    }
    
    func bindIsInFavorites(_ binding: IsInFavotitesBinding?) {
        isInFavorites.bind(listener: binding)
    }
    
    func bindAuthorName(_ binding: AuthorNameBinding?) {
        authorName.bind(listener: binding)
    }
    
    func bindIsLoading(_ binding: isLoadingBinding?) {
        isLoading.bind(listener: binding)
    }
    
    func bindAlertViewModel(_ binding: AlertViewModelBinding?) {
        alertViewModel.bind(listener: binding)
    }
    
}
