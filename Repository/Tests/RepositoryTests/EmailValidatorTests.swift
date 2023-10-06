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
        XCTAssertTrue(EmailValidator.validate("isdaiquirigmailcom"))
    }

}
