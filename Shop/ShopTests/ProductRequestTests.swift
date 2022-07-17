//
//  ProductRequestTests.swift
//  ShopTests
//
//  Created by Pavel Olegovich on 30.06.2022.
//

import XCTest
@testable import Shop

class ProductRequestTests: XCTestCase {
    let expectation = XCTestExpectation(description: "Download https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")
    
    var productRequest: GetProductRequestFactory!
    
    override func setUpWithError() throws {
        productRequest = RequestFactory().makeGetProductRequestFactory()
    }
    
    override func tearDownWithError() throws {
        productRequest = nil
    }
    
    
    func testGetCatalog() throws {
        let expressionCatalogsStub = [
            Product(id: 123, productName: "Ноутбук", productPrice: 45600),
            Product(id: 456, productName: "Мышка", productPrice: 1000)
        ]
        
        productRequest.getListProducts(pageNumber: 1, idCategory: 1) { response in
            switch response.result {
            case let .success(catalog):
                XCTAssertEqual(catalog[0].id, expressionCatalogsStub[0].id)
                XCTAssertEqual(catalog[1].id, expressionCatalogsStub[1].id)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testGetProductById() {
           
           let expressionProductStub = ProductResult(result: 1,
                                                     productName: "Ноутбук",
                                                     productPrice: 45600,
                                                     productDescription: "Мощный игровой ноутбук")
           
           productRequest.getProductById(productId: 123) { response in
               switch response.result {
               case .success(let product):
                   XCTAssertEqual(expressionProductStub.result, product.result)
                   XCTAssertEqual(expressionProductStub.productName, product.productName)
               case .failure(let error):
                   XCTFail(error.localizedDescription)
               }
               
               self.expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 10.0)
       }
}
