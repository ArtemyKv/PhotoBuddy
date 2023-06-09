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
        tableView.separatorStyle = .none
        tableView.register(FavoritePhotoTableViewCell.self, forCellReuseIdentifier: FavoritePhotoTableViewCell.identifier)
        viewModel.bindCellViewModels { [weak self] _ in
            self?.tableView.reloadData()
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInList()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoTableViewCell.identifier, for: indexPath) as? FavoritePhotoTableViewCell,
            let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
        else { return UITableViewCell() }
        
        cellViewModel.bindPhoto { photo in
            cell.update(with: photo)
        }
        cellViewModel.bindAuthorName { name in
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
