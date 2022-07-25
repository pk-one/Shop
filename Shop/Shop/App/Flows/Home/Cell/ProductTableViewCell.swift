//
//  ProductTableViewCell.swift
//  Shop
//
//  Created by Pavel Kruchinin on 25.07.2022.
//

import Foundation
import UIKit

final class ProductTableViewCell: UITableViewCell {
    
    static let cellID = "ProductTableViewCell"
    
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowRadius = 10
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    private let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let priceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        return $0
    }(UILabel())
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
        
    private func setupUI() {
        self.addSubview(mainView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(model: Product) {
        nameLabel.text = model.productName
        priceLabel.text = "Цена: \(model.productPrice)₽"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
