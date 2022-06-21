//
//  ViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 07.06.2022.
//

import UIKit
import Combine
import SPAlert

class AuthorizationViewController: UIViewController, RegistrationRouter, TabbarRouter {
    
    enum Authorization: String, LocalizableProtocol {
        case welcome
        case login
        case password
        case dontHaveAnAccount
        case signIn
        case register
        case error
        case emptyLoginOrPassword
    }
    
    var viewModel: AuthorizationViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let welcomeLabel = UILabel(text: Authorization.welcome.value, font: .avenir26())
    private let loginLabel = UILabel(text: Authorization.login.value)
    private let passwordLabel = UILabel(text: Authorization.password.value)
    private let needAnAccountLabel = UILabel(text: Authorization.dontHaveAnAccount.value)
    
    private let loginTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    
    private let signInButton = UIButton(title: Authorization.signIn.value, titleColor: .white, backgroundColor: .buttonGreen(), cornerRadius: 4)
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Authorization.register.value, for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private var keyboardIsShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupViews()
        setupNavigationBar()
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
                case .successAuthorization:
                    DispatchQueue.main.async {
                        self.openTabbar()
                    }
                case let .failedAuthorization(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Authorization.error.value,
                                        message: message,
                                        preset: .error,
                                        haptic: .error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
  
    private func setupViews() {
        title = ""
        view.backgroundColor = .systemBackground
        

        passwordTextField.isSecureTextEntry = true
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc private func didTapSignUp() {
        openRegistrationScreen()
    }
    
    @objc private func didTapSignIn() {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        
        guard !login.isEmpty || !password.isEmpty else {
            SPAlert.present(title: Authorization.error.value, message: Authorization.emptyLoginOrPassword.value, preset: .error, haptic: .error)
            return
        }
        
        viewModel.requestAuth(userName: login, password: password)
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
extension AuthorizationViewController {
    func setConstraints() {
        let loginStackView = UIStackView(arrangedSubviews: [loginLabel, loginTextField],
                                         axis: .vertical,
                                         spacing: 0)
        
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical,
                                            spacing: 0)
        
        
        let stackView = UIStackView(arrangedSubviews: [loginStackView, passwordStackView, signInButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(welcomeLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 60),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),

            welcomeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            bottomStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
