//
//  UISegmentedControl + Extension.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit

extension UISegmentedControl {
    convenience init(firstSegment: String, secondSegment: String) {
        self.init()
        self.insertSegment(withTitle: firstSegment, at: 0, animated: true)
        self.insertSegment(withTitle: secondSegment, at: 1, animated: true)
        self.selectedSegmentIndex = 0
        self.selectedSegmentTintColor = .buttonGreen()
        self.backgroundColor = .tabbarMainGray()
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
