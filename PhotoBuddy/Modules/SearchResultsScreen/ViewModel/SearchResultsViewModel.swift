//
//  SearchResultsViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 14.11.2022.


//

import Foundation

protocol SearchResultsViewModelProtocol: AnyObject {
    typealias IsLoadingBinding = (Bool) -> Void
    typealias CellViewModelsBinding = ([CellViewModel]) -> Void
    typealias AlertViewModelBinding = (AlertViewModel?) -> Void
    
    func bindIsLoading(_ binding: IsLoadingBinding?)
    func bindCellViewModels(_ binding: CellViewModelsBinding?)
    func bindAlertViewModel(_ binding: AlertViewModelBinding?)
    
    func searchButtonClicked(searchText: String)
    func viewDidEndDecelerating(withVisibleItemsAt indexPaths: [IndexPath])
}

final class SearchResultsViewModel: SearchResultsViewModelProtocol {
    
    private var photoFetchingManager = PhotoFetchingManager.shared
    
    private var photoInfoList: [BriefPhotoInfo] = []
    
    private var cellViewModels = Box<[CellViewModel]>(value: [])
    private var isLoading = Box(value: false)
    private var alertViewModel = Box<AlertViewModel?>(value: nil)
    
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    private var isWaitingForNextPage = true
    private var currentSearchText: String = ""
    
    //MARK: - Loading photos
        
    private func loadPhotoInfo(withSearchText searchText: String, isLoadingNewPage: Bool) {
        isLoading.value = true
        let searchDelay: DispatchTime = isLoadingNewPage ? .now() + 1 : .now()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: searchDelay) {
            self.photoFetchingManager.fetchSearchPhotoInfo(
                searchTerm: searchText,
                page: self.currentPage) { [weak self] photoResponse, error in
                    self?.isLoading.value = false
                    self?.isWaitingForNextPage = true
                    guard let photoResponse = photoResponse, let photoInfoList = photoResponse.photoInfos else {
                        if let error = error {
                            self?.setAlertWith(title: "Error", message: error.description)
                        }
                        return
                    }
                    self?.numberOfPages = photoResponse.totalPages
                    self?.photoInfoList.append(contentsOf: photoInfoList)
                    self?.makeCellViewModels(withPhotoInfoList: photoInfoList)
                    if photoInfoList.isEmpty {
                        self?.setAlertWith(title: "Oops!", message: "No photos found")
                        return
                    }
                }
        }
    }
    
    private func performNewSearch(withSearchText searchText: String) {
        currentPage = 1
        currentSearchText = searchText
        photoInfoList = []
        cellViewModels.value = []
        loadPhotoInfo(withSearchText: searchText, isLoadingNewPage: false)
        
    }
    
    private func loadNextPage() {
        isWaitingForNextPage = false
        currentPage += 1
        loadPhotoInfo(withSearchText: currentSearchText, isLoadingNewPage: true)
    }
    
    private func setAlertWith(title: String?, message: String?) {
        if let title, let message {
            self.alertViewModel.value = AlertViewModel(title: title, message: message)
        } else {
            self.alertViewModel.value = nil
        }
    }
    
    //MARK: - Binding methods
    
    func bindIsLoading(_ binding: IsLoadingBinding?) {
        isLoading.bind(listener: binding)
    }
    
    func bindCellViewModels(_ binding: CellViewModelsBinding?) {
        cellViewModels.bind(listener: binding)
    }
    
    func bindAlertViewModel(_ binding: AlertViewModelBinding?) {
        alertViewModel.bind(listener: binding)
    }
    
    //MARK: - Creating ViewModels
    
    func detailInfoViewModel(forPhotoAt indexPath: IndexPath) -> PhotoDetailsViewModel {
        let photoInfo = photoInfoList[indexPath.row]
        let viewModel = PhotoDetailsViewModel(briefPhotoInfo: photoInfo)
        return viewModel
    }

    private func makeCellViewModels(withPhotoInfoList list: [BriefPhotoInfo]) {
        for photoInfo in list {
            let cellViewModel = CellViewModel(photoInfo: photoInfo)
            cellViewModels.value.append(cellViewModel)
        }
    }
    
    //MARK: - Inputs
    
    func searchButtonClicked(searchText: String) {
        guard searchText != currentSearchText else { return }
        performNewSearch(withSearchText: searchText)
    }
    
    func viewDidEndDecelerating(withVisibleItemsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(IndexPath(row: cellViewModels.value.count - 1, section: 0)) else { return }
        guard isWaitingForNextPage else { return }
        guard currentPage < numberOfPages else { return }
        loadNextPage()
        
    }
}
