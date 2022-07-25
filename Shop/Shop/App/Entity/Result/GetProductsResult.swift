//
//  GetProductsResults.swift
//  Shop
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import Foundation

struct GetProductsResults: Codable {
    let pageNumber: Int
    
    struct Product: Codable {
        let productId: Int
        let productName: String
        let price: Int
        
        enum CodingKeys: String, CodingKey {
            case productId = "id_product"
            case productName = "product_name"
            case price
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
    }
}


struct ProductResult: Codable {
    let result: Int
    let productName: String
    let productPrice: Int
    let productDescription: String

    enum CodingKeys: String, CodingKey {
        case result
        case productName = "product_name"
        case productPrice = "product_price"
        case productDescription = "product_description"
    }
}
