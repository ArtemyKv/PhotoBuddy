//
//  TabBarController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        makeChildControllers()
    }
    
    private func makeChildControllers() {
        let searchResultsViewModel = SearchResultsViewModel()
        let searchPhotosVC = SearchResultsViewController(viewModel: searchResultsViewModel)
        let firstTabNavigationController = UINavigationController(rootViewController: searchPhotosVC)
        
        let favoritesViewModel = FavoritesViewModel()
        let favoritePhotosVC = FavoritePhotosViewController(viewModel: favoritesViewModel)
        let secondTabNavigationController = UINavigationController(rootViewController: favoritePhotosVC)
        viewControllers = [firstTabNavigationController, secondTabNavigationController]
        
        let firstTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 0)
        
        firstTabNavigationController.tabBarItem = firstTabBarItem
        secondTabNavigationController.tabBarItem = secondTabBarItem
    }
    
    private func configureTabBar() {
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
    }
}
