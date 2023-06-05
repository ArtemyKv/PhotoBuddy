//
//  PhotoListViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 22.11.2022.
//

import Foundation

class PhotoListViewModel {
    var photoInfoList: [BriefPhotoInfo] = []
    var cellViewModels = Box<[CellViewModel]>(value: [])
    
    var cellViewModelsCount: Int {
        return cellViewModels.value.count
    }

    func detailInfoViewModel(forPhotoAt indexPath: IndexPath) -> PhotoDetailsViewModel {
        let photoInfo = photoInfoList[indexPath.row]
        let viewModel = PhotoDetailsViewModel(briefPhotoInfo: photoInfo)
        return viewModel
    }

    func makeCellViewModels(withPhotoInfoList list: [BriefPhotoInfo]) {
        for photoInfo in list {
            let cellViewModel = CellViewModel(photoInfo: photoInfo)
            cellViewModels.value.append(cellViewModel)
        }
    }
    
    typealias CellViewModelsBinding = ([CellViewModel]) -> Void
    
    func bindCellViewModels(_ binding: CellViewModelsBinding?) {
        cellViewModels.bind(listener: binding)
    }
}
