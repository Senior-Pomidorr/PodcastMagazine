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
    private var spy: ReducerSpy<RegistrationDomain.Action>!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init(
            validateEmail: { _ in false },
            validatePassword: { _ in false }
        )
        spy = .init()
        state = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        spy = nil
        
        try await super.tearDown()
    }
    
    func test_setEmail() {
        state.email = ""
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertEqual(state.email, "Baz")
    }
    
    func test_emailIsValid() {
        state.isEmailValid = false
        sut = .init(validateEmail: { _ in true })
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertTrue(state.isEmailValid)
    }
    
    func test_emptyEmailIsValid() {
        state.isEmailValid = false
        sut = .init(validateEmail: { _ in true })
        
        _ = sut.reduce(&state, action: .setEmail(""))
        
        XCTAssertTrue(state.isEmailValid)
    }
    
    func test_emailIsInvalid() {
        state.isEmailValid = true
        sut = .init(validateEmail: { _ in false })
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertFalse(state.isEmailValid)
    }
    
    func test_continueButtonTap() {
        state.completeAccountPresented = false
        
        _ = sut.reduce(&state, action: .continueButtonTap)
        
        XCTAssertTrue(state.completeAccountPresented)
    }
    
    func test_dismissCompleteAccountView() {
        state.completeAccountPresented = true
        
        _ = sut.reduce(&state, action: .dismissCompleteAccount)
        
        XCTAssertFalse(state.completeAccountPresented)
    }
    
    func test_setFirstName() {
        state.firstName = ""
        
        _ = sut.reduce(&state, action: .setFirstName(" Baz "))
        
        XCTAssertEqual(state.firstName, "Baz")
    }
    
    func test_setLastName() {
        state.lastName = ""
        
        _ = sut.reduce(&state, action: .setLastName(" Baz "))
        
        XCTAssertEqual(state.lastName, "Baz")
    }

    func test_setPassword() {
        state.password = ""
        
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertEqual(state.password, "Baz")
    }
    
    func test_passwordIsValit() {
        state.isPasswordValid = false
        sut = .init(validatePassword: { _ in true })
        
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertTrue(state.isPasswordValid)
    }
    
    func test_passwordIsInvalid() {
        state.isPasswordValid = true
        sut = .init(validatePassword: { _ in false })
        
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertFalse(state.isPasswordValid)
    }
    
    func test_signUoButtonTapWithInvalidCredentials() {
        state.email = .init()
        state.password = .init()
        state.isEmailValid = false
        state.isPasswordValid = false
        state.firstName = .init()
        state.lastName = .init()
        
        spy.schedule(
            sut.reduce(&state, action: .signUpButtonTap)
        )
        
        XCTAssertEqual(spy.actions.count, 1)
        XCTAssertEqual(spy.actions.first, ._invalidCredentials)
    }
    
    func test_reduceInvalidCredentials() {
        state.isAlert = false
        
        _ = sut.reduce(&state, action: ._invalidCredentials)
        
        XCTAssertTrue(state.isAlert)
        XCTAssertEqual(state.alertText, "Baz")
    }
    
    func test_reduceDismissAlert() {
        state.isAlert = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.isAlert)
        XCTAssertTrue(state.alertText.isEmpty)
    }
    
    func test_signUpButtonTapWithValidCredentials() {
        state.email = "Baz"
        state.password = "Bar"
        state.isEmailValid = true
        state.isPasswordValid = true
        state.firstName = "Baz"
        state.lastName = "Bar"
        
        spy.schedule(
            sut.reduce(&state, action: .signUpButtonTap)
        )
        
        XCTAssertEqual(spy.actions.count, 1)
        XCTAssertEqual(spy.actions.first, ._createNewUserRequest)
    }
    
    func test_createNewUserRequestEndWithSuccess() {
        
    }
}
