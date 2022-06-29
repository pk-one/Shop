//
//  Product.swift
//  Shop
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import Foundation

struct Product: Codable {
    let id: Int
    let productName: String
    let productPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_product"
        case productName = "product_name"
        case productPrice = "price"
    }
}
