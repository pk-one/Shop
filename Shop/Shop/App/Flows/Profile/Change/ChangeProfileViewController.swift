//
//  ChangeViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit
import SPAlert
import Combine

final class ChangeProfileViewController: UIViewController {
    
    enum ChangeProfile: String, LocalizableProtocol {
        case username
        case password
        case email
        case gender
        case cardNumber
        case bio
        case save
        case error
        case emptyData
        case successChange
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
        
        var fullValue: String {
            switch self {
            case .male:
                return "Мужской"
            case .female:
                return "Женский"
            }
        }
    }
    
    var viewModel: ChangeProfileViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private let usernameLabel = UILabel(text: ChangeProfile.username.value)
    private let passwordLabel = UILabel(text: ChangeProfile.password.value)
    private let emailLabel = UILabel(text: ChangeProfile.email.value)
    private let genderLabel = UILabel(text: ChangeProfile.gender.value)
    
    private let cardLabel = UILabel(text: ChangeProfile.cardNumber.value)
    private let bioLabel = UILabel(text: ChangeProfile.bio.value)
    
    private let usernameTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    private let emailTextField = OneLineTextField(font: .avenir20())
    
    private let genderSegmentedControl = UISegmentedControl(firstSegment: Genders.male.fullValue, secondSegment: Genders.female.fullValue)
    private let cardTextField = OneLineTextField(font: .avenir20())
    private let bioTextField = OneLineTextField(font: .avenir20())
        
    private let saveButton = UIButton(title: ChangeProfile.save.value,
                                titleColor: .white,
                                backgroundColor: .buttonGreen(),
                                cornerRadius: 4)
    
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
                case .successChange:
                    DispatchQueue.main.async {
                        SPAlert.present(message: ChangeProfile.successChange.value, haptic: .success) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case let .failedChange(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: ChangeProfile.error.value, message: message, preset: .error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        passwordTextField.isSecureTextEntry = true
        cardTextField.keyboardType = .numberPad
        
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .buttonGreen()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc private func didTapSave() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text,
              let gender = Genders(rawValue: genderSegmentedControl.selectedSegmentIndex)?.value
        else { return }
        
        guard !username.isEmpty
                && !password.isEmpty
                && !email.isEmpty
        else {
            SPAlert.present(title: ChangeProfile.error.value, message: ChangeProfile.emptyData.value, preset: .error, haptic: .error)
            return
        }
        
        let user = ProfileResult(userId: 123,
                           login: username,
                           password: password,
                           email: email,
                           gender: gender,
                           creditCard: cardTextField.text ?? "",
                           bio: bioTextField.text ?? "")
        
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
extension ChangeProfileViewController {
    private func setConstraints() {
        
        let usernameStackView = createStackView(arrangedSubviews: [usernameLabel, usernameTextField])
        
        let passwordStackView = createStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        
        let emailStackView = createStackView(arrangedSubviews: [emailLabel, emailTextField])
        
        let genderStackView = createStackView(arrangedSubviews: [genderLabel, genderSegmentedControl])
        
        let cardStackView = createStackView(arrangedSubviews:  [cardLabel, cardTextField])
        
        let bioStackView = createStackView(arrangedSubviews: [bioLabel, bioTextField])
        
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = createStackView(arrangedSubviews: [usernameStackView,
                                                           passwordStackView,
                                                           emailStackView,
                                                           genderStackView,
                                                           cardStackView,
                                                           bioStackView,
                                                           saveButton],
                                        spacing: 20)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
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
