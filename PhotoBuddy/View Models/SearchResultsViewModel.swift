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

class SearchResultsViewModel: PhotoListViewModel {
    
    weak var delegate: SearchResultsViewModelDelegate?
    
    private var photoFetchingManager = PhotoFetchingManager.shared
    
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    private var currentSearchTerm: String = ""
    
    var photoInfoList: [BriefPhotoInfo] = []
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    func searchPhotos(searchTerm: String, completion: @escaping () -> Void) {
        guard !(searchTerm == currentSearchTerm && currentPage >= numberOfPages) else { return }
        if searchTerm != currentSearchTerm {
            currentPage = 1
            currentSearchTerm = searchTerm
            self.photoInfoList = []
            self.cellViewModels.value = []
        } else {
            currentPage += 1
        }
        photoFetchingManager.fetchSearchPhotoInfo(searchTerm: searchTerm, page: currentPage) { [weak self] photoResponse, error in
            guard let photoResponse = photoResponse, let photoInfoList = photoResponse.photoInfos else {
                self?.presentAlert(withError: error!)
                return
            }
            self?.numberOfPages = photoResponse.totalPages
            self?.photoInfoList.append(contentsOf: photoInfoList)
            self?.createCellViewModels(withPhotoInfoList: photoInfoList)
            completion()
        }
    }
    
    private func presentAlert(withError error: PhotosFetchingError) {
        delegate?.presentAlert(message: error.localizedDescription)
    }
}
