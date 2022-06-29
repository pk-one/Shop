//
//  HomeViewModel.swift
//  Shop
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import Foundation
import Combine

enum GetProductsState {
    case successfulReceiptProductsList(_ catalog: [Product])
    case successfulReceiptProduct(_ product: ProductResult)
    case failedfulReceipt(_ message: String)
}

protocol HomeViewModeling: AnyObject {
    var state: PassthroughSubject<GetProductsState, Never> { get }
    
    func getListProducts(pageNumber: Int, idCategory: Int)
    func getProductById(productId: Int)
}

final class HomeViewModel: HomeViewModeling {
    var state = PassthroughSubject<GetProductsState, Never>()
    
    private let requestFactory: GetProductRequestFactory
    
    init(requestFactory: GetProductRequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func getListProducts(pageNumber: Int, idCategory: Int) {
        requestFactory.getListProducts(pageNumber: pageNumber, idCategory: idCategory) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
            case let .success(products):
                print(products)
                self.state.send(.successfulReceiptProductsList(products))
            case let .failure(error):
                print(error)
                self.state.send(.failedfulReceipt(error.localizedDescription))
            }
        }
    }
    
    func getProductById(productId: Int) {
        requestFactory.getProductById(productId: productId) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
                
            case let .success(product):
                print(product)
                self.state.send(.successfulReceiptProduct(product))
            case let .failure(error):
                print(error)
                self.state.send(.failedfulReceipt(error.localizedDescription))
            }
        }
    }
}
