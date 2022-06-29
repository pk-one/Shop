//
//  HomeViewController.swift
//  Shop
//
//  Created by Pavel Olegovich on 15.06.2022.
//

import Foundation
import UIKit
import SPAlert
import Combine

final class HomeViewController: UIViewController {
    
    enum Home: String, LocalizableProtocol {
        case getProductsList
        case getProduct
        case error
        case successful
        case successfulReceiptProductsList
        case successfulReceiptProduct
    }
    
    var viewModel: HomeViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let getProductsListButton = UIButton(title: Home.getProductsList.value, titleColor: .white, backgroundColor: .buttonRed(), cornerRadius: 4)
    private let getProductButton = UIButton(title: Home.getProduct.value, titleColor: .white, backgroundColor: .buttonRed(), cornerRadius: 4)
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
            .sink { state in
                
                switch state {
                    
                case let .successfulReceiptProductsList(catalog):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Home.successful.value,
                                        message: Home.successfulReceiptProductsList.value,
                                        preset: .done,
                                        haptic: .success)
                        
                        let _ = catalog.map { print("\($0.productName) за \($0.productPrice) руб.")}
                    }
                    
                case let .failedfulReceipt(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Home.error.value,
                                        message: message,
                                        preset: .error,
                                        haptic: .error)
                    }
                case let .successfulReceiptProduct(product):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Home.successful.value,
                                        message: Home.successfulReceiptProduct.value,
                                        preset: .done,
                                        haptic: .success)
                        
                        print("Продукт: \(product.productName)\nОписание: \(product.productDescription)")
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setupViews() {
        stackView = UIStackView(arrangedSubviews: [getProductsListButton,
                                                   getProductButton],
                                axis: .vertical,
                                spacing: 10)
        view.addSubview(stackView)
        
        getProductsListButton.translatesAutoresizingMaskIntoConstraints = false
        getProductButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        getProductsListButton.addTarget(self, action: #selector(didTapGetProductsList), for: .touchUpInside)
        getProductButton.addTarget(self, action: #selector(didTapGetProduct), for: .touchUpInside)
    }
    
    @objc private func didTapGetProductsList() {
        viewModel.getListProducts(pageNumber: 1, idCategory: 1)
    }
    
    @objc private func didTapGetProduct() {
        viewModel.getProductById(productId: 123)
    }
}

//MARK: - setConstraints
extension HomeViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            getProductsListButton.heightAnchor.constraint(equalToConstant: 60),
            getProductButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

