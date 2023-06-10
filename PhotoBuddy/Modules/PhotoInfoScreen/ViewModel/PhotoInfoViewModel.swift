//
//  PhotoInfoViewModel.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 21.11.2022.
//

import Foundation

protocol PhotoInfoViewModelProtocol: AnyObject {
    typealias Binding = (String) -> Void
    
    func bindAuthorName(_ binding: Binding?)
    func bindDescription(_ binding: Binding?)
    func bindCreationDate(_ binding: Binding?)
    func bindLocation(_ binding: Binding?)
    func bindDownloads(_ binding: Binding?)
}

class PhotoInfoViewModel: PhotoInfoViewModelProtocol {
    
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
    
    private var authorName = Box(value: "")
    private var description = Box(value: "")
    private var creatioDate = Box(value: "")
    private var location = Box(value: "")
    private var downloads = Box(value: "")
    
    private func configureViewModel(with info: DetailPhotoInfo) {
        authorName.value = info.authorName
        description.value = info.description ?? ""
        creatioDate.value = dateFormatter.string(from: info.creationDate)
        location.value = info.location.description
        downloads.value = "\(info.downloads)"
    }
    
    //MARK: - Bindings
    func bindAuthorName(_ binding: Binding?) {
        authorName.bind(listener: binding)
    }
    
    func bindDescription(_ binding: Binding?) {
        description.bind(listener: binding)
    }
    
    func bindCreationDate(_ binding: Binding?) {
        creatioDate.bind(listener: binding)
    }
    
    func bindLocation(_ binding: Binding?) {
        location.bind(listener: binding)
    }
    
    func bindDownloads(_ binding: Binding?) {
        downloads.bind(listener: binding)
    }
    
}
