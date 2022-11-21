//
//  PhotoInfoViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 21.11.2022.
//

import Foundation

class PhotoInfoViewModel {
    var detailPhotoInfo: DetailPhotoInfo? {
        didSet {
            guard let detailPhotoInfo = detailPhotoInfo else { return }
            configureViewModel(with: detailPhotoInfo)
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM, MMM d, yyyy"
        return formatter
    }()
    
    var authorName = Box(value: "")
    var description = Box(value: "")
    var creatioDate = Box(value: "")
    var location = Box(value: "")
    var downloads = Box(value: "")
    
    func configureViewModel(with info: DetailPhotoInfo) {
        authorName.value = info.authorName
        description.value = info.description ?? ""
        creatioDate.value = dateFormatter.string(from: info.creationDate)
        location.value = info.location.description
        downloads.value = "\(info.downloads)"
    }
}
