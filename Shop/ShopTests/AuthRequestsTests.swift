//
//  AuthRequestsTests.swift
//  Shop
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import XCTest
@testable import Shop

class AuthRequestsTests: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Download https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")

    var authRequest: AuthRequestFactory!
    var logoutRequest: LogoutRequestFactory!

    override func setUpWithError() throws {
        authRequest = RequestFactory().makeAuthRequestFatory()
        logoutRequest = RequestFactory().makeLogoutRequestFatory()
    }

    override func tearDownWithError() throws {
        authRequest = nil
        logoutRequest = nil
    }

    func testAuth() throws {
        let expressionLoginResultStub = LoginResult(result: 1,
                                                    user: User(id: 123,
                                                               login: "geekbrains",
                                                               name: "John",
                                                               lastname: "Doe"))
        
        authRequest.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case let .success(login):
                XCTAssertEqual(login.result, expressionLoginResultStub.result)
                XCTAssertEqual(login.user.id, expressionLoginResultStub.user.id)
                XCTAssertEqual(login.user.login, expressionLoginResultStub.user.login)
            
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLogout() throws {
        let expressionLogoutResultStub = LogoutResult(result: 1)
        
        logoutRequest.logout(userId: 123) { response in
            switch response.result {
            case let .success(logout):
                XCTAssertEqual(logout.result, expressionLogoutResultStub.result)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
