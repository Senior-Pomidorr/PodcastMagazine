//
//  ValidatorTests.swift
//  
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import XCTest
import Validator

final class ValidatorTests: XCTestCase {

    func test_emailValid() {
        XCTAssertTrue(Validator.validate(email: "isdaiquiri@gmail.com"))
    }
    
    func test_emailInvalid() {
        XCTAssertFalse(Validator.validate(email: "isdaiquirigmailcom"))
    }
    
    func test_emailWithDotInvalid() {
        XCTAssertFalse(Validator.validate(email: "isdaiquirigmail.com"))
    }
    
    func test_urlAddressIsInvalidEmail() {
        XCTAssertFalse(Validator.validate(email: "www.apple.com"))
    }
    
    func test_passwordValid() {
        XCTAssertTrue(Validator.validate(password: "Password1@"))
    }
    
    func test_passwordWithoutUppercasedCharIsInvalid() {
        XCTAssertFalse(Validator.validate(password: "password1@"))
    }
    
    func test_passwordWithoutDigitIsInvalid() {
        XCTAssertFalse(Validator.validate(password: "Password@"))
    }
    
    func test_passwordWithoutLowercaseIsInvalid() {
        XCTAssertFalse(Validator.validate(password: "PASSWORD1@"))
    }
    
    func test_passwordWithoutSymbolIsInvalid() {
        XCTAssertFalse(Validator.validate(password: "Password1"))
    }
    
    func test_passwordLessThanEightSymbol() {
        XCTAssertFalse(Validator.validate(password: "Pas@1"))
    }

}
