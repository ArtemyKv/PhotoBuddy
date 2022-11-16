//
//  ViewController.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 11.11.2022.
//

import UIKit

class SearchPhotosViewController: UIViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, CellViewModel>
    
    var dataSource: DataSourceType!
    var searchResultsViewModel = SearchResultsViewModel()
    
    enum Section {
        case main
    }
    
    var imageListView: ImageListView! {
        guard isViewLoaded else { return nil }
        return (self.view as! ImageListView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = configureDataSource()
        imageListView.collectionView.dataSource = dataSource
        imageListView.collectionView.collectionViewLayout = createLayout()
        imageListView.searchBar.delegate = self
        searchResultsViewModel.cellViewModels.bind { [weak self] items in
            self?.applySnapshot(with: items)
        }
        
    }
    
    override func loadView() {
        let imageListView = ImageListView()
        self.view = imageListView
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<PhotoCell, CellViewModel> {
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, CellViewModel> { cell, indexPath, cellViewModel in
            cellViewModel.photo.bind { image in
                cell.photoView.image = image
            }
            self.searchResultsViewModel.fetchImages(forCellViewModel: cellViewModel)
        }
        return cellRegistration
    }
    
    func configureDataSource() -> DataSourceType {
        let cellRegistration = self.cellRegistration()
        let dataSource = DataSourceType(collectionView: imageListView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func applySnapshot(with items: [CellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

extension SearchPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchResultsViewModel.searchPhotos(searchTerm: searchBar.text ?? "")
    }
}

