//
//  PhotoListViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 22.11.2022.
//

import Foundation

protocol PhotoListViewModel: AnyObject {
    var photoInfoList: [BriefPhotoInfo] { get set }
    var cellViewModels: Box<[CellViewModel]> { get set }
}

extension PhotoListViewModel {
    func detailInfoViewModel(forPhotoAt indexPath: IndexPath) -> PhotoDetailsViewModel {
        let photoInfo = photoInfoList[indexPath.row]
        let viewModel = PhotoDetailsViewModel(briefPhotoInfo: photoInfo)
        return viewModel
    }

    internal func createCellViewModels(withPhotoInfoList list: [BriefPhotoInfo]) {
        for photoInfo in list {
            let cellViewModel = CellViewModel(photoInfo: photoInfo)
            cellViewModels.value.append(cellViewModel)
        }
    }
}
