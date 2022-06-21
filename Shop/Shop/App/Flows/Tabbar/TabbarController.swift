//
//  TabbarViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit

final class TabbarController: UITabBarController, ProfileRouter {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        createTabbar()
        setupNavigationBar()
        setupTabbarAppearance()
    }
    
    
    private func createTabbar() {
        viewControllers = [
            generateViewController(viewController: HomeViewController(),
                                   title: "Главная",
                                   image: UIImage(systemName: "house.fill")),
            generateViewController(viewController: openProfile(),
                                   title: "Профиль",
                                   image: UIImage(systemName: "person.fill"))
        ]
    }
    
    private func generateViewController(viewController: UIViewController,
                                        title: String,
                                        image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setupTabbarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width, height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.tabbarMainGray().cgColor
        tabBar.tintColor = .buttonGreen()
        tabBar.unselectedItemTintColor = .tabbarUnselectedWhite()
    }
    
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
