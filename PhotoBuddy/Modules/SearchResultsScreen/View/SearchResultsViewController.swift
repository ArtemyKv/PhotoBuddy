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
    let viewModel: SearchResultsViewModelProtocol
        
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
    
    init(viewModel: SearchResultsViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.viewModel.bindIsLoading { isLoading in
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
        let searchResultsLayout = SearchResultsLayout()
        searchResultsLayout.delegate = self
        collectionView.collectionViewLayout = searchResultsLayout
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot(with items: [CellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupBindings() {
        viewModel.bindCellViewModels { [weak self] items in
            self?.applySnapshot(with: items)
            self?.imageListView.toggleBackgroundLabelsVisibility(shouldHide: !items.isEmpty)
        }
        
        viewModel.bindAlertViewModel { [weak self] alertViewModel in
            guard let alertViewModel else { return }
            self?.presentErrorAlert(title: alertViewModel.title, message: alertViewModel.message)
        }
    }
}

//MARK: - Extension UICollectionViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let detailInfoViewModel = viewModel.detailInfoViewModel(forPhotoAt: indexPath)
        let detailInfoVC = PhotoDetailsViewController(viewModel: detailInfoViewModel)
        self.navigationController?.pushViewController(detailInfoVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let indexPath = collectionView.indexPathsForVisibleItems
            viewModel.viewDidEndDecelerating(withVisibleItemsAt: indexPath)

    }
}

//MARK: - Extension UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        viewModel.searchButtonClicked(searchText: searchText)
    }
}

//MARK: -Extension AlertPresenter
extension SearchResultsViewController: AlertPresenter { }

//MARK: -Extension SearchResultsLayoutDelegate
extension SearchResultsViewController: SearchResultsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let imageSize = viewModel.imageSizeForItem(at: indexPath) else { return 180 }

        let imageScale = (collectionView.bounds.width / 2) / imageSize.width
        let imageHeight = imageSize.height * imageScale
        return imageHeight
        
    }
}
