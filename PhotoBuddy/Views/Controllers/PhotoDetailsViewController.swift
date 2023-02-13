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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.image.bind { [weak self] photo in
            guard let photo = photo else { return }
            self?.photoDetailsView.imageScrollView.set(image: photo)
        }
        viewModel.isInFavorites.bind { [weak self] isInFavorites in
            self?.photoDetailsView.configureFavoritesButton(isInFavorites: isInFavorites)
        }
        
        viewModel.authorName.bind { [weak self] authorName in
            self?.navigationItem.title = authorName
        }
        
        photoDetailsView.activityIndicatorView.startAnimating()
        
        viewModel.fetchDetailPhotoInfo { [weak self] errorTitle, errorMessage in
            if let errorTitle, let errorMessage {
                self?.presentErrorAlert(title: errorTitle, message: errorMessage)
            }
            self?.photoDetailsView.activityIndicatorView.stopAnimating()
        }

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

        viewModel.updateFavorites()
    }
    
    override func loadView() {
        let photoDetailsView = PhotoDetailsView()
        photoDetailsView.delegate = self
        self.view = photoDetailsView
    }
    
    func saveImageToDevice() {
        guard let photo = viewModel.image.value else { return }
        UIImageWriteToSavedPhotosAlbum(photo, self, #selector(imageDidFinishSavingOnDevice), nil)
    }
    
    @objc func imageDidFinishSavingOnDevice(
        image: UIImage!,
        didFinishSavingWithError error: NSError!,
        contextInfo: UnsafeRawPointer) {
            self.photoDetailsView.animateSavingCompletion()
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
    
    func saveButtonPressed() {
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self?.saveImageToDevice()
                        self?.photoDetailsView.animateImageSaving()
                    }
                case .denied:
                    DispatchQueue.main.async {
                        self?.presentAuthorizationStatusAlert(title: "Access denied", message: "Access to device photo library denied. You can change this in Settings")
                    }
                default:
                    break
            }
        }
    }
    

}

extension PhotoDetailsViewController: AlertPresenter { }
