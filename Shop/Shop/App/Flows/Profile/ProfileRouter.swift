//
//  ProfileRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit

protocol ProfileRouter: AnyObject {
    func openProfile() -> UIViewController
}

extension ProfileRouter where Self: UIViewController {
    func openProfile() -> UIViewController {
        let vc = ProfileViewController()
        vc.viewModel = ProfileViewModel(requestFactory: RequestFactory().makeLogoutRequestFatory())
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
}
