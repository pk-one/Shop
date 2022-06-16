//
//  OneLineTextField.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .textFieldLight()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
