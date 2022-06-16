//
//  SplashScreenRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit

protocol SplashScreenRouter: AnyObject {
    func openSplashScreen(window: UIWindow?)
}


extension SplashScreenRouter {
    
    func openSplashScreen(window: UIWindow?) {
        let viewModel = SplashScreenViewModel()
        let splashScreenViewController = SplashScreenViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: splashScreenViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
  
}
