//
//  DetailInfoViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

class DetailInfoViewController: UIViewController {
    
    let detailInfoViewModel: DetailInfoViewModel
    
    init(viewModel: DetailInfoViewModel) {
        self.detailInfoViewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfoViewModel.image.bind { [weak self] photo in
            guard let photo = photo else { return }
            self?.detailInfoView.imageScrollView.set(image: photo)
        }
        detailInfoViewModel.fetchDetailPhotoInfo()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    var detailInfoView: DetailInfoView! {
        guard isViewLoaded else { return nil }
        return (view as? DetailInfoView)
    }
    
    override func loadView() {
        let detailInfoView = DetailInfoView()
        self.view = detailInfoView
    }
}
