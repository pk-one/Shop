//
//  RegistrationRouter.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit

protocol RegistrationRouter: AnyObject {
    func openRegistrationScreen()
}

extension RegistrationRouter where Self: UIViewController {
    func openRegistrationScreen() {
        let vc = RegistrationViewController()
        vc.viewModel = RegistrationViewModel(requestFactory: RequestFactory().makeRegistrationRequestFatory())
        navigationController?.pushViewController(vc, animated: true)
    }
}
