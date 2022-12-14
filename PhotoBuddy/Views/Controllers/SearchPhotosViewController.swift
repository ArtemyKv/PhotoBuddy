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
    private var isWaitingForNextPage = true
    
    enum Section {
        case main
    }
    
    var imageListView: ImageListView! {
        guard isViewLoaded else { return nil }
        return (self.view as! ImageListView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        dataSource = configureDataSource()
        imageListView.collectionView.delegate = self
        imageListView.collectionView.dataSource = dataSource
        imageListView.collectionView.collectionViewLayout = createLayout()
        searchResultsViewModel.cellViewModels.bind { [weak self] items in
            self?.applySnapshot(with: items)
            self?.imageListView.toggleBackgroundLabelsVisibility(shouldHide: !items.isEmpty)
        }
        
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.automaticallyShowsCancelButton = false
        searchController.automaticallyShowsSearchResultsController = false
        self.navigationItem.searchController = searchController
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

        }
        return cellRegistration
    }
    
    func footerRegistration() -> UICollectionView.SupplementaryRegistration<BottomRefreshControl> {
        let footerRegistration = UICollectionView.SupplementaryRegistration<BottomRefreshControl>(elementKind: BottomRefreshControl.elementKind) { supplementaryView, elementKind, indexPath in
            self.searchResultsViewModel.isLoadingNextPage.bind { isLoading in
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
    
    func configureDataSource() -> DataSourceType {
        let cellRegistration = self.cellRegistration()
        let footerRegistration = self.footerRegistration()
        let dataSource = DataSourceType(collectionView: imageListView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
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
    
    func searchPhotos(searchTerm: String) {
        self.searchResultsViewModel.searchPhotos(searchTerm: searchTerm) { [weak self] alertTitle, alertMessage in
            if let alertTitle, let alertMessage {
                self?.presentErrorAlert(title: alertTitle, message: alertMessage)
                return
            }
            self?.isWaitingForNextPage = true
        }
    }
}

//MARK: - Extension UICollectionViewDelegate
extension SearchPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageListView.collectionView.deselectItem(at: indexPath, animated: true)
        let detailInfoViewModel = searchResultsViewModel.detailInfoViewModel(forPhotoAt: indexPath)
        let detailInfoVC = PhotoDetailsViewController(viewModel: detailInfoViewModel)
        self.navigationController?.pushViewController(detailInfoVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == searchResultsViewModel.cellViewModels.value.count - 1 && isWaitingForNextPage else { return }
        let searchTerm = self.navigationItem.searchController?.searchBar.text ?? ""
        isWaitingForNextPage = false
        searchPhotos(searchTerm: searchTerm)
    }
}

//MARK: - Extension UISearchBarDelegate
extension SearchPhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        searchPhotos(searchTerm: searchTerm)
    }
}

//MARK: -Extension AlertPresenter
extension SearchPhotosViewController: AlertPresenter { }
