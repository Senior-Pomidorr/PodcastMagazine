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
        
        sut = .init()
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
    
}

