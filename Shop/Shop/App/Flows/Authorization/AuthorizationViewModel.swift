//
//  AuthorizationViewModel.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import Combine

enum AuthorizationState {
    case successAuthorization
    case failedAuthorization(_ message: String)
}

protocol AuthorizationViewModeling: AnyObject {
    var state: PassthroughSubject<AuthorizationState, Never> { get }
    
    func requestAuth(userName: String, password: String) 
}

final class AuthorizationViewModel: AuthorizationViewModeling {
    
    var state = PassthroughSubject<AuthorizationState, Never>()
    
    private let requestFactory: AuthRequestFactory
    
    init(requestFactory: AuthRequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func requestAuth(userName: String, password: String) {
        requestFactory.login(userName: userName, password: password) { [weak self] response in
            guard let self = self else { return }
           
            switch response.result {
            case let .success(login):
                print(login)
                self.state.send(.successAuthorization)
            case let .failure(error):
                self.state.send(.failedAuthorization(error.localizedDescription))
            }
        }
    }
}
