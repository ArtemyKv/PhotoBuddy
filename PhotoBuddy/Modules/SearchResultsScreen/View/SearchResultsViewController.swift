//
//  ViewController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 11.11.2022.
//

import UIKit

class SearchResultsViewController: UIViewController {
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
    
    var collectionView: UICollectionView {
        return imageListView.collectionView
    }
    
    override func loadView() {
        let imageListView = ImageListView()
        self.view = imageListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        makeDataSource()
        configureCollectionView()
        setupBindings()
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.automaticallyShowsCancelButton = false
        searchController.automaticallyShowsSearchResultsController = false
        self.navigationItem.searchController = searchController
    }
    
    func makeDataSource() {
        let cellRegistration = cellRegistration()
        let footerRegistration = footerRegistration()
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
        
        self.dataSource = dataSource
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<PhotoCell, CellViewModel> {
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, CellViewModel> { cell, indexPath, cellViewModel in
            cellViewModel.bindPhoto { image in
                cell.photoView.image = image
            }
        }
        return cellRegistration
    }
    
    func footerRegistration() -> UICollectionView.SupplementaryRegistration<BottomRefreshControl> {
        let footerRegistration = UICollectionView.SupplementaryRegistration<BottomRefreshControl>(elementKind: BottomRefreshControl.elementKind) { supplementaryView, elementKind, indexPath in
            self.searchResultsViewModel.bindIsLoading { isLoading in
                DispatchQueue.main.async {
                    if isLoading {
                        supplementaryView.indicator.startAnimating()
                    } else {
                        supplementaryView.indicator.stopAnimating()
                    }
                }
            }
        }
        return footerRegistration
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let sectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))

        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionFooterSize, elementKind: BottomRefreshControl.elementKind, alignment: .bottom)

        section.boundarySupplementaryItems = [footer]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func applySnapshot(with items: [CellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    func setupBindings() {
        searchResultsViewModel.bindCellViewModels { [weak self] items in
            self?.applySnapshot(with: items)
            self?.imageListView.toggleBackgroundLabelsVisibility(shouldHide: !items.isEmpty)
        }
        
        searchResultsViewModel.bindAlertViewModel { [weak self] alertViewModel in
            guard let alertViewModel else { return }
            self?.presentErrorAlert(title: alertViewModel.title, message: alertViewModel.message)
        }
    }
}

//MARK: - Extension UICollectionViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let detailInfoViewModel = searchResultsViewModel.detailInfoViewModel(forPhotoAt: indexPath)
        let detailInfoVC = PhotoDetailsViewController(viewModel: detailInfoViewModel)
        self.navigationController?.pushViewController(detailInfoVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        searchResultsViewModel.viewWillDisplayCell(forItemAt: indexPath.row)
    }
}

//MARK: - Extension UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        searchResultsViewModel.searchButtonClicked(searchText: searchText)
    }
}

//MARK: -Extension AlertPresenter
extension SearchResultsViewController: AlertPresenter { }
