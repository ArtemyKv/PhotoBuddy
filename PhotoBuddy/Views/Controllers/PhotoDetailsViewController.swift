//
//  DetailInfoViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

class PhotoDetailsViewController: UIViewController {
    
    let viewModel: PhotoDetailsViewModel
    
    var photoDetailsView: PhotoDetailsView! {
        guard isViewLoaded else { return nil }
        return (view as? PhotoDetailsView)
    }
    
    init(viewModel: PhotoDetailsViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.alertPresenter = self
        viewModel.image.bind { [weak self] photo in
            guard let photo = photo else { return }
            self?.photoDetailsView.imageScrollView.set(image: photo)
        }
        viewModel.isInFavorites.bind { [weak self] isInFavorites in
            self?.photoDetailsView.configureFavoritesButton(isInFavorites: isInFavorites)
        }
        
        viewModel.fetchDetailPhotoInfo()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.updateFavorites()
    }
    
    override func loadView() {
        let photoDetailsView = PhotoDetailsView()
        photoDetailsView.delegate = self
        self.view = photoDetailsView
    }
}

extension PhotoDetailsViewController: PhotoDetailsViewDelegate {
    func toggleFavoritesButtonPressed() {
        viewModel.isInFavorites.value.toggle()
    }
    
    func infoButtonPressed() {
        let viewModel = viewModel.photoInfoViewModel
        let infoViewController = InfoViewController(photoInfoViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: infoViewController)
        self.present(navigationController, animated: true)
    }
}

extension PhotoDetailsViewController: AlertPresenter { }
