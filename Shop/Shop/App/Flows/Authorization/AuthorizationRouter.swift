//
//  AuthorizationRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit

protocol AuthorizationRouter: AnyObject {
    func openAuhorizationScreen()
}

extension AuthorizationRouter where Self: UIViewController {
    func openAuhorizationScreen() {
        let vc = AuthorizationViewController()
        vc.viewModel = AuthorizationViewModel(requestFactory: RequestFactory().makeAuthRequestFatory())
        AppDelegate.mainWindow.rootViewController = UINavigationController(rootViewController: vc)
    }
}
