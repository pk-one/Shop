//
//  ProfileResult.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation

struct ProfileResult: Codable {
    let userId: Int
    let login: String
    let password: String
    let email: String
    let gender: String
    let creditCard: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id_user"
        case login = "username"
        case password = "password"
        case email = "email"
        case gender = "gender"
        case creditCard = "credit_card"
        case bio = "bio"
    }
}
