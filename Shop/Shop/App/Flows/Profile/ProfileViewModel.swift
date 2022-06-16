//
//  ProfileViewModel.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import Combine

enum LogoutState {
    case successLogout
    case failedLogout(_ message: String)
}

protocol ProfileViewModeling: AnyObject {
    var state: PassthroughSubject<LogoutState, Never> { get }
    
    func requestLogout(userId: Int)
}

final class ProfileViewModel: ProfileViewModeling {
    
    var state = PassthroughSubject<LogoutState, Never>()
    
    private let requestFactory: LogoutRequestFactory
    
    init(requestFactory: LogoutRequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func requestLogout(userId: Int) {
        requestFactory.logout(userId: userId) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
                
            case let .success(logout):
                print(logout)
                self.state.send(.successLogout)
            case let .failure(error):
                print(error)
                self.state.send(.failedLogout(error.localizedDescription))
            }
        }
    }
}
