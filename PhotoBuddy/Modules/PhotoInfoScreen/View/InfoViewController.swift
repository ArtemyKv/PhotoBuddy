//
//  InfoViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 21.11.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    let photoInfoViewModel: PhotoInfoViewModelProtocol
    
    var photoInfoView: PhotoInfoView! {
        guard isViewLoaded else { return nil }
        return (view as? PhotoInfoView)
    }
    
    init(photoInfoViewModel: PhotoInfoViewModelProtocol) {
        self.photoInfoViewModel = photoInfoViewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let photoInfoView = PhotoInfoView()
        self.view = photoInfoView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupNavigationBar()
        setupBindings()
        
    }
    
    private func setupNavigationBar() {
        self.navigationItem.setLeftBarButton(
            UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed)),
            animated: true
        )
    }
    
    private func setupBindings() {
        photoInfoViewModel.bindAuthorName { [weak self] text in
            self?.photoInfoView.authorNameLabel.text = text
        }
        photoInfoViewModel.bindDescription { [weak self] text in
            self?.photoInfoView.descriptionLabel.text = text
        }
        photoInfoViewModel.bindLocation { [weak self] text in
            self?.photoInfoView.locationLabel.text = text
        }
        photoInfoViewModel.bindCreationDate { [weak self] text in
            self?.photoInfoView.creationDateLabel.text = text
        }
        photoInfoViewModel.bindDownloads { [weak self] text in
            self?.photoInfoView.downloadsCountLabel.text = text
        }
    }
    
     @objc func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
}
