//
//  Change.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import Alamofire

protocol ChangeProfileRequestFactory {
    func change(for user: ProfileResult, completion: @escaping (AFDataResponse<ChangeResult>) -> Void)
}

final class ChangeProfile: AbstractRequestFactory {
    
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

extension ChangeProfile: ChangeProfileRequestFactory {
    func change(for user: ProfileResult, completion: @escaping (AFDataResponse<ChangeResult>) -> Void) {
        
        let requestModel = UserChange(baseUrl: baseUrl, profile: user)
        
        request(request: requestModel, completion: completion)
    }
}

extension ChangeProfile {
    struct UserChange: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "changeUserData.json"
        
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
