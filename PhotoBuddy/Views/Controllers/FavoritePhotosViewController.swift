//
//  FavoritePhotosViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 15.11.2022.
//

import Foundation
import UIKit

class FavoritePhotosViewController: UITableViewController {
    
    let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        tableView.register(FavoritePhotoTableViewCell.self, forCellReuseIdentifier: FavoritePhotoTableViewCell.identifier)
        viewModel.cellViewModels.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoTableViewCell.identifier, for: indexPath) as! FavoritePhotoTableViewCell
        let cellViewModel = viewModel.cellViewModels.value[indexPath.row]
        cellViewModel.photo.bind { photo in
            cell.photoView.image = photo
        }
        cellViewModel.authorName.bind { name in
            cell.authorNameLabel.text = name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailInfoViewModel = viewModel.detailInfoViewModel(forPhotoAt: indexPath)
        let photoDetailVC = PhotoDetailsViewController(viewModel: detailInfoViewModel)
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
