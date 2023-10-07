//
//  EmailValidatorTests.swift
//  
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import XCTest
import AuthorizationDomain

final class EmailValidatorTests: XCTestCase {

    func test_emailValid() {
        XCTAssertTrue(EmailValidator.validate("isdaiquiri@gmail.com"))
    }
    
    func test_emailInvalid() {
        XCTAssertFalse(EmailValidator.validate("isdaiquirigmailcom"))
    }
    
    func test_emailWithDotInvalid() {
        XCTAssertFalse(EmailValidator.validate("isdaiquirigmail.com"))
    }
    
    func test_urlAddressIsInvalidEmail() {
        XCTAssertFalse(EmailValidator.validate("www.apple.com"))
    }

}
