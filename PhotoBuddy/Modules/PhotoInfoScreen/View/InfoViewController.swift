//
//  InfoViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 21.11.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    var photoInfoViewModel: PhotoInfoViewModel
    
    var photoInfoView: PhotoInfoView! {
        guard isViewLoaded else { return nil }
        return (view as? PhotoInfoView)
    }
    
    init(photoInfoViewModel: PhotoInfoViewModel) {
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
        view.backgroundColor = .white
        self.navigationItem.setLeftBarButton(
            UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed)),
            animated: true
        )
        configureView()
        
    }
    
    func configureView() {
        photoInfoViewModel.authorName.bind { [weak self] value in
            self?.photoInfoView.authorNameLabel.text = value
        }
        photoInfoViewModel.description.bind { [weak self] value in
            self?.photoInfoView.descriptionLabel.text = value
        }
        photoInfoViewModel.location.bind { [weak self] value in
            self?.photoInfoView.locationLabel.text = value
        }
        photoInfoViewModel.creatioDate.bind { [weak self] value in
            self?.photoInfoView.creationDateLabel.text = value
        }
        photoInfoViewModel.downloads.bind { [weak self] value in
            self?.photoInfoView.downloadsCountLabel.text = value
        }
    }
    
     @objc func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
}
