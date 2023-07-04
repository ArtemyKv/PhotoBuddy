//
//  FavoritesViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 22.11.2022.
//

import Foundation
import CoreData

protocol FavoritesViewModelProtocol: AnyObject {
    func numberOfRowsInList() -> Int
    func cellViewModel(at index: Int) -> CellViewModel?
    func detailInfoViewModel(forPhotoAt indexPath: IndexPath) -> PhotoDetailsViewModel

    typealias CellViewModelsBinding = ([CellViewModel]) -> Void
    func bindCellViewModels(_ binding: CellViewModelsBinding?)
}

final class FavoritesViewModel:FavoritesViewModelProtocol {

    private var managedContext = CoreDataStack.shared.managedContext
    
    private var photoInfoList: [BriefPhotoInfo] = []
    private var cellViewModels = Box<[CellViewModel]>(value: [])
    
    init() {
        makePhotoList()
        addNotificationObservers()
    }
    
    private func makePhotoList() {
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
                let width = Int(photoInfo.width)
                let height = Int(photoInfo.height)
                let briefPhotoInfo = BriefPhotoInfo(id: id, width: width, height: height, blurHash: blurHash, url: url, authorName: authorName)
                photoInfoList.append(briefPhotoInfo)
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error), description: \(error.userInfo)")
        }
        makeCellViewModels(withPhotoInfoList: photoInfoList)
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
    
    private func makeCellViewModels(withPhotoInfoList list: [BriefPhotoInfo]) {
        for photoInfo in list {
            let cellViewModel = CellViewModel(photoInfo: photoInfo)
            cellViewModels.value.append(cellViewModel)
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
    
    func numberOfRowsInList() -> Int {
        return cellViewModels.value.count
    }
    
    func cellViewModel(at index: Int) -> CellViewModel? {
        guard index < cellViewModels.value.count else { return nil }
        return cellViewModels.value[index]
    }
    
    func detailInfoViewModel(forPhotoAt indexPath: IndexPath) -> PhotoDetailsViewModel {
        let photoInfo = photoInfoList[indexPath.row]
        let viewModel = PhotoDetailsViewModel(briefPhotoInfo: photoInfo)
        return viewModel
    }

    func bindCellViewModels(_ binding: CellViewModelsBinding?) {
        cellViewModels.bind(listener: binding)
    }
}
