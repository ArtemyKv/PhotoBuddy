//
//  SearchResultsViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

protocol SearchResultsViewModelDelegate: AnyObject {
    func presentAlert(message: String)
}

class SearchResultsViewModel {
    
    weak var delegate: SearchResultsViewModelDelegate?
    
    var photoFetchingManager = PhotoFetchingManager()
    
    var photoInfoList: [BriefPhotoInfo] = []
    
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    func searchPhotos(searchTerm: String) {
        photoFetchingManager.fetchSearchPhotoInfo(searchTerm: searchTerm) { [weak self] photoInfoList, error in
            guard let photoInfoList = photoInfoList else {
                self?.presentAlert(withError: error!)
                return
            }
            self?.createCellViewModels(withPhotoInfoList: photoInfoList)
        }
    }
    
    func fetchImages(forCellViewModel cellViewModel: CellViewModel) {
        let imageUrl = cellViewModel.photoInfo.url
        self.photoFetchingManager.downloadPhoto(url: imageUrl) { image in
            cellViewModel.photo.value = image
        }
    }
    
    private func presentAlert(withError error: PhotosFetchingError) {
        delegate?.presentAlert(message: error.localizedDescription)
    }
    
    private func createCellViewModels(withPhotoInfoList list: [BriefPhotoInfo]) {
        cellViewModels.value = []
        for photoInfo in list {
            let cellViewModel = CellViewModel(photoInfo: photoInfo)
            cellViewModels.value.append(cellViewModel)
        }
    }
}
