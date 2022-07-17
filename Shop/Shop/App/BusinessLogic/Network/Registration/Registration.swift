//
//  Registration.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import Alamofire

protocol RegistrationRequestFactory {
    func register(for user: ProfileResult, completion: @escaping (AFDataResponse<RegistrationResult>) -> Void)
}

final class Registration: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    
    init(errorParser: AbstractErrorParser, sessionManager: Session, queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Registration: RegistrationRequestFactory {
    func register(for user: ProfileResult, completion: @escaping (AFDataResponse<RegistrationResult>) -> Void) {
        
        let requestModel = UserRegistration(baseUrl: baseUrl, profile: user)
        
        request(request: requestModel, completion: completion)
    }
}

extension Registration {
    struct UserRegistration: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "registerUser.json"
        
        let profile: ProfileResult
        
        var parameters: Parameters? {
            return [
                "id_user": profile.userId,
                "username": profile.login,
                "password": profile.password,
                "email": profile.email,
                "gender": profile.gender,
                "credit_card": profile.creditCard ?? "",
                "bio": profile.bio ?? ""
            ]
        }
    }
}
