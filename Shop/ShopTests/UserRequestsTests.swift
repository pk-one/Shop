//
//  UserRequestsTests.swift
//  ShopTests
//
//  Created by Pavel Olegovich on 29.06.2022.
//

import XCTest
@testable import Shop

class UserRequestsTests: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Download https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")
    
    var registrationRequest: RegistrationRequestFactory!
    var changeProfileRequest: ChangeProfileRequestFactory!

    override func setUpWithError() throws {
        registrationRequest = RequestFactory().makeRegistrationRequestFatory()
        changeProfileRequest = RequestFactory().makeChangeProfileRequestFatory()
    }

    override func tearDownWithError() throws {
        registrationRequest = nil
        changeProfileRequest = nil
    }

    func testRegister() throws {
        let expressionRegResultStub = RegistrationResult(result: 1,
                                                         userMessage: "Регистрация прошла успешно!")
        let profile = createProfile()
        registrationRequest.register(for: profile) { response in
            switch response.result {
            case let .success(register):
                XCTAssertEqual(register.result, expressionRegResultStub.result)
                XCTAssertEqual(register.userMessage, expressionRegResultStub.userMessage)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testChange() throws {
        let expressionChangeResultStub = ChangeResult(result: 1)
        
        let profile = createProfile()
        changeProfileRequest.change(for: profile) { response in
            switch response.result {
            case let .success(change):
                XCTAssertEqual(change.result, expressionChangeResultStub.result)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    private func createProfile() -> ProfileResult {
        ProfileResult(userId: 123,
                      login: "Somebody",
                      password: "mypassword",
                      email: "some@some.ru",
                      gender: "m",
                      creditCard: "9872389-2424-234224-234",
                      bio: "This is good! I think I will switch to another language")
    }
}
