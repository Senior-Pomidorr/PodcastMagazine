//
//  RegistrationDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import XCTest
import RegistrationDomain
import SwiftUDF

final class RegistrationDomainTests: XCTestCase {
    private var sut: RegistrationDomain!
    private var state: RegistrationDomain.State!
    
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
    
    func test_setEmail() {
        state.email = ""
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertEqual(state.email, "Baz")
    }

}
