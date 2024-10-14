//
//  TabBarController.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        tabBar.backgroundColor = .black

        UITabBar.appearance().tintColor = .highlight
        UITabBar.appearance().unselectedItemTintColor = .white
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .normal
        )
        
        appearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .selected
        )
        
        let trendVC = UINavigationController(rootViewController: UIViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let favoriteVC = UINavigationController(
            rootViewController: FavoriteViewController()
        )
        
        trendVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        favoriteVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        searchVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        
        viewControllers = [
            trendVC,
            searchVC,
            favoriteVC
        ]
    }
}
