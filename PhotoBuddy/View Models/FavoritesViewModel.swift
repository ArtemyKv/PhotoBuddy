//
//  FavoritesViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 22.11.2022.
//

import Foundation
import CoreData

class FavoritesViewModel: PhotoListViewModel {
    
    var photoInfoList: [BriefPhotoInfo] = []
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    var managedContext = CoreDataStack.shared.managedContext
    
    init() {
        createPhotoList()
        addNotificationObservers()
    }
    
    private func createPhotoList() {
        let request = CachedBriefPhotoInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addToFavoritesDate", ascending: true)]
        do {
            let cachedPhotoInfoList = try managedContext.fetch(request)
            for photoInfo in cachedPhotoInfoList {
                guard
                    let id = photoInfo.photoID,
                    let blurHash = photoInfo.blurHash,
                    let url = photoInfo.url,
                    let authorName = photoInfo.authorName
                else { continue }
                let briefPhotoInfo = BriefPhotoInfo(id: id, blurHash: blurHash, url: url, authorName: authorName)
                photoInfoList.append(briefPhotoInfo)
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error), description: \(error.userInfo)")
        }
        createCellViewModels(withPhotoInfoList: photoInfoList)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: PhotoDetailsViewModel.addToFavoritesNotification,
            object: nil,
            queue: nil) { [weak self] notification in
                guard let photoInfo = notification.userInfo?["photoInfo"] as? BriefPhotoInfo else { return }
                self?.addPhotoToList(photoInfo: photoInfo)
            }
        NotificationCenter.default.addObserver(
            forName: PhotoDetailsViewModel.removeFromFavoritesNotification,
            object: nil,
            queue: nil) { [weak self] notification in
                guard let photoInfo = notification.userInfo?["photoInfo"] as? BriefPhotoInfo else { return }
                self?.removePhotoFromList(photoInfo: photoInfo)
            }
        
    }
    
    private func addPhotoToList(photoInfo: BriefPhotoInfo) {
        photoInfoList.append(photoInfo)
        cellViewModels.value.append(CellViewModel(photoInfo: photoInfo))
    }
    
    private func removePhotoFromList(photoInfo: BriefPhotoInfo) {
        guard let index = photoInfoList.firstIndex(of: photoInfo) else { return }
        photoInfoList.remove(at: index)
        cellViewModels.value.remove(at: index)
    }
}
