//
//  TabbarRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit

protocol TabbarRouter: AnyObject {
    func openTabbar()
}

extension TabbarRouter where Self: UIViewController {
    func openTabbar() {
        let tabbar = TabbarController()
        navigationController?.pushViewController(tabbar, animated: true)
    }
}
