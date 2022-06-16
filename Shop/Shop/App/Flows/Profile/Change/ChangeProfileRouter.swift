//
//  ChangeRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit

protocol ChangeProfileRouter: AnyObject {
    func openChangeProfile()
}

extension ChangeProfileRouter where Self: UIViewController {
    func openChangeProfile() {
        let vc = ChangeProfileViewController()
        vc.viewModel = ChangeProfileViewModel(requestFactory: RequestFactory().makeChangeProfileRequestFatory())
        navigationController?.pushViewController(vc, animated: true)
    }
}
