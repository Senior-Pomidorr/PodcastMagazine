//
//  AuthorizationDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import XCTest
import AuthorizationDomain

final class AuthorizationDomainTests: XCTestCase {
    private var sut: AuthorizationDomain!
    private var state: AuthorizationDomain.State!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init(repository: .preview())
        state = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        
        try await super.tearDown()
    }
    
    func test_setEmailAction() {
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertEqual(state.email, "Baz")
    }
    
    func test_setPassword() {
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertEqual(state.password, "Baz")
    }
    
    func test_setInvalidEmail() {
        sut = .init(
            repository: .preview(),
            emailValidation: { _ in false }
        )
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertFalse(state.isEmailValid)
    }
    
    func test_setValidEmail() {
        sut = .init(
            repository: .preview(),
            emailValidation: { _ in true }
        )
        
        _ = sut.reduce(&state, action: .setEmail("Bar"))
        
        XCTAssertTrue(state.isEmailValid)
    }
    
    func test_setEmailEmptyState() {
        _ = sut.reduce(&state, action: .setEmail(""))
        
        XCTAssertTrue(state.email.isEmpty)
        XCTAssertTrue(state.isEmailValid)
    }
    
}

