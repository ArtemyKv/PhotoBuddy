//
//  TabBarController.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChildControllers()
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .label
        self.tabBar.backgroundColor = .systemBackground

    }
    
    func createChildControllers() {
        let searchPhotosVC = SearchPhotosViewController()
        let firstTabNavigationController = UINavigationController(rootViewController: searchPhotosVC)
        
        let favoritePhotosVC = FavoritePhotosViewController()
        let secondTabNavigationController = UINavigationController(rootViewController: favoritePhotosVC)
        self.viewControllers = [firstTabNavigationController, secondTabNavigationController]
        
        let firstTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 0)
        
        firstTabNavigationController.tabBarItem = firstTabBarItem
        secondTabNavigationController.tabBarItem = secondTabBarItem
    }
}
