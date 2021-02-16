//
//  TabBarController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/18/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let mainViewController = MainViewController()
    let storageViewController = StorageViewController()
    let featuredViewControler = FeaturedViewController([.added, .deleted])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor(hex: "#20B483")
        
        mainViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 1)
        storageViewController.tabBarItem = UITabBarItem(title: "Storage", image: UIImage(named: "storage"), tag: 2)
        featuredViewControler.tabBarItem = UITabBarItem(title: "Featured", image: UIImage(named: "featured"), tag: 3)
        
        viewControllers = [mainViewController, storageViewController, featuredViewControler]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = mainViewController.navigationItem.titleView
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1 {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationItem.titleView = viewController.navigationItem.titleView
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
