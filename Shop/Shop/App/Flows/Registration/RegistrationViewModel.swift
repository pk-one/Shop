//
//  RegistrationViewModel.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import Combine

enum RegistrationState {
    case successRegistration(_ message: String)
    case failedRegistration(_ message: String)
}

protocol RegistrationViewModeling: AnyObject {
    var state: PassthroughSubject<RegistrationState, Never> { get }
    
    func requestRegistration(user: ProfileResult)
}

final class RegistrationViewModel: RegistrationViewModeling {
    
    var state = PassthroughSubject<RegistrationState, Never>()
    
    private let requestFactory: RegistrationRequestFactory
    
    init(requestFactory: RegistrationRequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func requestRegistration(user: ProfileResult) {
        requestFactory.register(for: user) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
                
            case let .success(result):
                print(result)
                self.state.send(.successRegistration(result.userMessage))
            case let .failure(error):
                print(error)
                self.state.send(.failedRegistration(error.localizedDescription))
            }
        }
    }
}
