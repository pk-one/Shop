//
//  LocalizableProtocol.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation

protocol LocalizableProtocol: RawRepresentable {
    var value: String { get }
}

extension LocalizableProtocol {
    var value: String {
        let key = rawValue as! String
        let table = String(describing: Self.self)
        let value = Bundle.main.localizedString(forKey: key, value: nil, table: table)
        return value
    }
}

