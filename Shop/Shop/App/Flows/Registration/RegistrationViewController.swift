//
//  RegistrationViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 14.06.2022.
//

import Foundation
import UIKit
import SPAlert
import Combine

final class RegistrationViewController: UIViewController, AuthorizationRouter {
    
    enum Registration: String, LocalizableProtocol {
        case username
        case password
        case email
        case gender
        case cardNumber
        case bio
        case register
        case error
        case emptyData
    }
    
    private enum Genders: Int {
        case male
        case female
        
        var value: String {
            switch self {
            case .male:
                return "m"
            case .female:
                return "f"
            }
        }
    }
    
    var viewModel: RegistrationViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private let usernameLabel = UILabel(text: Registration.username.value)
    private let passwordLabel = UILabel(text: Registration.password.value)
    private let emailLabel = UILabel(text: Registration.email.value)
    private let genderLabel = UILabel(text: Registration.gender.value)
    
    private let cardLabel = UILabel(text: Registration.cardNumber.value)
    private let bioLabel = UILabel(text: Registration.bio.value)
    
    private let usernameTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    private let emailTextField = OneLineTextField(font: .avenir20())
    
    private let genderSegmentedControl = UISegmentedControl(firstSegment: "Мужской", secondSegment: "Женский")
    private let cardTextField = OneLineTextField(font: .avenir20())
    private let bioTextField = OneLineTextField(font: .avenir20())
        
    private let signInButton = UIButton(title: Registration.register.value,
                                titleColor: .white,
                                backgroundColor: .buttonGreen(),
                                cornerRadius: 4)
    
    private var keyboardIsShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupViews()
        setConstraints()
        configureNotificationForKeyboard()
        configureTapGesture()
    }
    
    deinit {
        removeNotificationForKeyboard()
    }
    
    private func setupBindings() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case let .successRegistration(message):
                    DispatchQueue.main.async {
                        SPAlert.present(message: message, haptic: .success) {
                            self.openAuhorizationScreen()
                        }
                    }
                case let .failedRegistration(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Registration.error.value, message: message, preset: .error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(isHidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigationBar(isHidden: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        passwordTextField.isSecureTextEntry = true
        cardTextField.keyboardType = .numberPad
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    private func setupNavigationBar(isHidden: Bool) {
        navigationController?.navigationBar.tintColor = .buttonGreen()
        navigationController?.navigationBar.isHidden = isHidden
    }
    
    @objc private func didTapSignIn() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text,
              let gender = Genders(rawValue: genderSegmentedControl.selectedSegmentIndex)?.value
        else { return }
        
        guard !username.isEmpty
                && !password.isEmpty
                && !email.isEmpty
        else {
            SPAlert.present(title: Registration.error.value, message: Registration.emptyData.value, preset: .error, haptic: .error)
            return
        }
        
        let user = ProfileResult(userId: 123, login: username, password: password, email: email, gender: gender, creditCard: cardTextField.text ?? "", bio: bioTextField.text ?? "")
        viewModel.requestRegistration(user: user)
    }
    
    private func configureNotificationForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationForKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo as NSDictionary?
        let keyboardSize = (userInfo?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.height + 20
            scrollView.contentInset = contentInset
        self.keyboardIsShow = true
    }
    
    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
        self.scrollView.endEditing(true)
        self.keyboardIsShow = false
    }
    
    private func configureTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTouch(gesture:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func handleTouch(gesture: UITapGestureRecognizer) {
        
        if self.keyboardIsShow {
            keyboardWillHide()
            return
        }
    }
}

//MARK: - setConstraints
extension RegistrationViewController {
    private func setConstraints() {
        
        let usernameStackView = createStackView(arrangedSubviews: [usernameLabel, usernameTextField])
        
        let passwordStackView = createStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        
        let emailStackView = createStackView(arrangedSubviews: [emailLabel, emailTextField])
        
        let genderStackView = createStackView(arrangedSubviews: [genderLabel, genderSegmentedControl])
        
        let cardStackView = createStackView(arrangedSubviews:  [cardLabel, cardTextField])
        
        let bioStackView = createStackView(arrangedSubviews: [bioLabel, bioTextField])
        
        signInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = createStackView(arrangedSubviews: [usernameStackView,
                                                           passwordStackView,
                                                           emailStackView,
                                                           genderStackView,
                                                           cardStackView,
                                                           bioStackView,
                                                           signInButton],
                                        spacing: 20)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createStackView(arrangedSubviews: [UIView], spacing: CGFloat? = 0) -> UIStackView {
        return UIStackView(arrangedSubviews: arrangedSubviews,
                                       axis: .vertical,
                                       spacing: spacing ?? 0)
    }
}
