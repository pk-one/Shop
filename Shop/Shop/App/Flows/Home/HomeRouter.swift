//
//  HomeRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import Foundation
import UIKit

protocol HomeRouter: AnyObject {
    func openHome() -> UIViewController
}

extension ProfileRouter where Self: UIViewController {
    func openHome() -> UIViewController {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel(requestFactory: RequestFactory().makeGetProductRequestFactory())
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
}

