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
        case error
        case successful
        case successfulReceiptProductsList
    }
    
    var viewModel: HomeViewModeling!
    private var subscriptions = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.cellID)
        $0.separatorStyle = .none
        return $0
    }(UITableView())
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBindings()
        setupViews()
        setConstraints()
        setDelegates()
        loadProducts()
    }
    
    private func setupBindings() {
        viewModel.state
            .sink { state in
                
                switch state {
                    
                case let .successfulReceiptProductsList(catalog):
                    self.products = catalog
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case let .failedfulReceipt(message):
                    DispatchQueue.main.async {
                        SPAlert.present(title: Home.error.value,
                                        message: message,
                                        preset: .error,
                                        haptic: .error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func loadProducts() {
        viewModel.getListProducts(pageNumber: 1, idCategory: 1)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
}

//MARK: - setConstraints
extension HomeViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellID, for: indexPath) as? ProductTableViewCell else { return UITableViewCell()}
        cell.setData(model: products[indexPath.row])
        return cell
    }
}
