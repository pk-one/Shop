//
//  ProfileViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit
import SPAlert
import Combine

final class ProfileViewController: UIViewController, AuthorizationRouter, ChangeProfileRouter {
    
    enum Profile: String, LocalizableProtocol {
        case logout
        case error
        case change
    }
    
    var viewModel: ProfileViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let changeProfileButton = UIButton(title: Profile.change.value, titleColor: .white, backgroundColor: .buttonRed(), cornerRadius: 4)
    private let logoutButton = UIButton(title: Profile.logout.value, titleColor: .white, backgroundColor: .buttonRed(), cornerRadius: 4)
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBindings()
        setupViews()
        setConstraints()
    }
    
    private func setupBindings() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .successLogout:
                    DispatchQueue.main.async {
                        self.openAuhorizationScreen()
                    }
                case let .failedLogout(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Profile.error.value,
                                        message: message,
                                        preset: .error,
                                        haptic: .error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setupViews() {
        stackView = UIStackView(arrangedSubviews: [changeProfileButton,
                                                       logoutButton],
                                    axis: .vertical,
                                    spacing: 10)
        view.addSubview(stackView)
        
        changeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        changeProfileButton.addTarget(self, action: #selector(didTapChangeProfile), for: .touchUpInside)
    }
    
    @objc private func didTapLogout() {
        let user = 123
        viewModel.requestLogout(userId: user)
    }
    
    @objc private func didTapChangeProfile() {
        openChangeProfile()
    }
}

//MARK: - setConstraints
extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 60),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 60),

        ])
    }
}

