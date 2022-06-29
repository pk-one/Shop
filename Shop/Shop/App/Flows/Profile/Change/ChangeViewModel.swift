//
//  ChangeViewModel.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import Combine

enum ChangeState {
    case successChange
    case failedChange(_ message: String)
}

protocol ChangeProfileViewModeling: AnyObject {
    var state: PassthroughSubject<ChangeState, Never> { get }
    
    func requestRegistration(user: ProfileResult)
}

final class ChangeProfileViewModel: ChangeProfileViewModeling {
    
    var state = PassthroughSubject<ChangeState, Never>()
    
    private let requestFactory: ChangeProfileRequestFactory
    
    init(requestFactory: ChangeProfileRequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func requestRegistration(user: ProfileResult) {
        requestFactory.change(for: user) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
                
            case let .success(result):
                print(result)
                self.state.send(.successChange)
            case let .failure(error):
                print(error)
                self.state.send(.failedChange(error.localizedDescription))
            }
        }
    }
}
