//
//  SearchResultsViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

class SearchResultsViewModel: PhotoListViewModel {
    
    weak var alertPresenter: AlertPresenter?
    
    private var photoFetchingManager = PhotoFetchingManager.shared
    
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    private var currentSearchTerm: String = ""
    
    var photoInfoList: [BriefPhotoInfo] = []
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    var isLoadingNextPage = Box(value: false)
    
    func searchPhotos(searchTerm: String, completion: @escaping () -> Void) {
        isLoadingNextPage.value = true
        guard !(searchTerm == currentSearchTerm && currentPage >= numberOfPages) else {
            self.isLoadingNextPage.value = false
            return
        }
        var searchDelay: DispatchTime = .now()
        if searchTerm != currentSearchTerm {
            currentPage = 1
            currentSearchTerm = searchTerm
            self.photoInfoList = []
            self.cellViewModels.value = []
        } else {
            currentPage += 1
            searchDelay = .now() + 1
        }
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: searchDelay) {
            self.photoFetchingManager.fetchSearchPhotoInfo(
                searchTerm: searchTerm,
                page: self.currentPage) { [weak self] photoResponse, error in
                    
                    self?.isLoadingNextPage.value = false
                    guard let photoResponse = photoResponse, let photoInfoList = photoResponse.photoInfos else {
                        self?.presentAlert(withError: error!)
                        return
                    }
                    self?.numberOfPages = photoResponse.totalPages
                    self?.photoInfoList.append(contentsOf: photoInfoList)
                    self?.createCellViewModels(withPhotoInfoList: photoInfoList)
                    if photoInfoList.isEmpty {
                        self?.alertPresenter?.presentErrorAlert(title: "Oops!", message: "No photos found")
                    }
                    completion()
            }
        }
        
    }
    
    private func presentAlert(withError error: PhotosFetchingError) {
        alertPresenter?.presentErrorAlert(title: "Error", message: error.description)
    }
}
