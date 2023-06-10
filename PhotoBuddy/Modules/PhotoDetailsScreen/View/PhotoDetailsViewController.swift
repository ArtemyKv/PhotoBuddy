//
//  DetailInfoViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit
import Photos

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
    
    override func loadView() {
        let photoDetailsView = PhotoDetailsView()
        photoDetailsView.delegate = self
        self.view = photoDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        viewModel.viewWillDisappear()
    }
    
    func setupBindings() {
        viewModel.bindPhoto { [weak self] photo in
            guard let photo = photo else { return }
            self?.photoDetailsView.imageScrollView.set(image: photo)
        }
        
        viewModel.bindIsInFavorites { [weak self] isInFavorites in
            self?.photoDetailsView.configureFavoritesButton(isInFavorites: isInFavorites)
        }
        
        viewModel.bindAuthorName { [weak self] authorName in
            self?.navigationItem.title = authorName
        }
        
        viewModel.bindIsLoading { [weak self] isLoading in
            if isLoading {
                self?.photoDetailsView.activityIndicatorView.startAnimating()
            } else {
                self?.photoDetailsView.activityIndicatorView.stopAnimating()
            }
        }
        
        viewModel.bindAlertViewModel { [weak self] alertViewModel in
            guard let alertViewModel else { return }
            self?.presentErrorAlert(title: alertViewModel.title, message: alertViewModel.message)
        }
    }
}

extension PhotoDetailsViewController: PhotoDetailsViewDelegate {
    func toggleFavoritesButtonPressed() {
        viewModel.toggleFavoritesButtonPressed()
    }
    
    func infoButtonPressed() {
        let viewModel = viewModel.photoInfoViewModel
        let infoViewController = InfoViewController(photoInfoViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: infoViewController)
        self.present(navigationController, animated: true)
    }
    
    func saveButtonPressed() {
        DispatchQueue.main.async {
            self.saveImageOnDevice()
            self.photoDetailsView.animateImageSaving()
        }
    }
    
    func saveImageOnDevice() {
        guard let photo = viewModel.getPhoto() else { return }
        UIImageWriteToSavedPhotosAlbum(photo, self, #selector(imageDidFinishSavingOnDevice), nil)
    }
    
    @objc func imageDidFinishSavingOnDevice(
        image: UIImage!,
        didFinishSavingWithError error: NSError!,
        contextInfo: UnsafeRawPointer) {
            self.photoDetailsView.animateSavingCompletion()
    }
}

extension PhotoDetailsViewController: AlertPresenter { }
