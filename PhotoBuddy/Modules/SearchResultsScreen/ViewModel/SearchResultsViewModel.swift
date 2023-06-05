//
//  SearchResultsViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

class SearchResultsViewModel: PhotoListViewModel {
    
    
    private var photoFetchingManager = PhotoFetchingManager.shared
    
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    private var currentSearchTerm: String = ""
    
    var photoInfoList: [BriefPhotoInfo] = []
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    var cellViewModelsCount: Int {
        return cellViewModels.value.count
    }
    
    var isLoadingNextPage = Box(value: false)
    
    func searchPhotos(searchTerm: String, completion: @escaping (_ alertTitle: String?, _ alertMessage: String?) -> Void) {
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
                        if let error = error {
                            completion("Error", error.description)
                        }
                        return
                    }
                    self?.numberOfPages = photoResponse.totalPages
                    self?.photoInfoList.append(contentsOf: photoInfoList)
                    self?.makeCellViewModels(withPhotoInfoList: photoInfoList)
                    if photoInfoList.isEmpty {
                        completion("Oops!", "No photos found")
                        return
                    }
                    completion(nil, nil)
            }
        }
    }
    
    typealias CellViewModelsBinding = ([CellViewModel]) -> Void
    
    func bindCellViewModels(_ binding: CellViewModelsBinding?) {
        cellViewModels.bind(listener: binding)
    }
    
    typealias IsLoadingNextPageBinding = (Bool) -> Void
    
    func bindIsLoadingNextPage(_ binding: IsLoadingNextPageBinding?) {
        isLoadingNextPage.bind(listener: binding)
    }
}
