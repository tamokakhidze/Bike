//
//  RootViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

// MARK: - RootViewController

class RootViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBar()
    }
    
    // MARK: - Ui setup
    
    private func setupView() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupTabBar() {
        let tabBarController = UITabBarController()
        
        let homeVC = HomeViewController()
        let leaderboardVC = LeaderboardHostingVC()
        let shopVC = ShopHostingViewController()
        let profileVC = ProfileHostingController()
        
        tabBarController.viewControllers = [homeVC, leaderboardVC, shopVC, profileVC]
        
        configureTabBarItems(for: homeVC, leaderboardVC: leaderboardVC, shopVC: shopVC, profileVC: profileVC)
        
        if let tabBar = tabBarController.tabBar as? UITabBar {
            tabBar.barTintColor = .white
            tabBar.isTranslucent = true
            tabBar.backgroundColor = .clear
            tabBar.tintColor = .black
            tabBar.layer.cornerRadius = 40
            tabBar.layer.masksToBounds = true
        }
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
    
    private func configureTabBarItems(for homeVC: UIViewController, leaderboardVC: UIViewController, shopVC: UIViewController, profileVC: UIViewController) {
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: .home, tag: 1)
        leaderboardVC.tabBarItem = UITabBarItem(title: "Leaderboard", image: Images.trophy, tag: 2)
        shopVC.tabBarItem = UITabBarItem(title: "Shop", image: .shopTabBarIcon, tag: 4)
        profileVC.tabBarItem = UITabBarItem(title: "profile", image: Images.profile, tag: 3)
    }
    
}

// MARK: - Constants Extension

extension RootViewController {
    enum Images {
        static let trophy = UIImage(systemName: "trophy")
        static let profile = UIImage(systemName: "person")
    }
    
    enum Titles {
        static let home = "Home"
    }
}
