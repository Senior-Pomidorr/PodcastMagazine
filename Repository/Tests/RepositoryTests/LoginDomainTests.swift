//
//  LoginDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import XCTest
import LoginDomain
import SwiftUDF
import Models
import Repository
import Combine

final class LoginDomainTests: XCTestCase {
    private var sut: LoginDomain!
    private var state: LoginDomain.State!
    private var spy: ReducerSpy<LoginDomain.Action>!
    private var testUser: UserAccount!
    
    override func setUp() async throws {
        try await super.setUp()
        
        testUser = UserAccount(firstName: "Baz", lastName: "Bar", email: "Foo")
        sut = .init(
            repository: .preview(),
            validateEmail: { _ in false },
            validatePassword: { _ in false }
        )
        state = .init()
        spy = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        spy = nil
        testUser = nil
        
        try await super.tearDown()
    }
    
    func test_setEmailAction() {
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertEqual(state.email, "Baz")
    }
    
    func test_setInvalidEmail() {
        sut = makeSUT(isCredValid: false)
        
        _ = sut.reduce(&state, action: .setEmail("Baz"))
        
        XCTAssertFalse(state.isEmailValid)
    }
    
    func test_setValidEmail() {
        state.isEmailValid = false
        sut = makeSUT()
        
        _ = sut.reduce(&state, action: .setEmail("Bar"))
        
        XCTAssertTrue(state.isEmailValid)
    }
    
    func test_setEmailEmptyState() {
        state.isEmailValid = false
        
        _ = sut.reduce(&state, action: .setEmail(""))
        
        XCTAssertTrue(state.email.isEmpty)
        XCTAssertTrue(state.isEmailValid)
    }
    
    func test_setPassword() {
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertEqual(state.password, "Baz")
    }
    
    func test_setValidPassword() {
        state.isPasswordValid = false
        sut = .init(
            repository: .preview(),
            validatePassword: { _ in true }
        )
        
        _ = sut.reduce(&state, action: .setPassword("Baz"))
        
        XCTAssertTrue(state.isPasswordValid)
    }
    
    func test_isLoginButtonActiveGetTrue() {
        state.email = "Baz"
        state.password = "Bar"
        state.isEmailValid = true
        state.isPasswordValid = true
        
        XCTAssertTrue(state.isLoginButtonActive)
    }
    
    func test_loginButtonTap() {
        spy.schedule(
            sut.reduce(&state, action: .loginButtonTap)
        )
        
        XCTAssertEqual(spy.actions.count, 1)
        XCTAssertEqual(spy.actions.first, ._loginRequest)
    }
    
    func test_loginRequestEndWithSuccess() {
        sut = .init(repository: .init(login: { _, _ in
            Just(.success(self.testUser))
                .eraseToAnyPublisher()
        }))
        
        spy.schedule(
            sut.reduce(&state, action: ._loginRequest)
        )
        
        XCTAssertEqual(spy.actions.count, 1)
        XCTAssertEqual(spy.actions.first, ._loginResponse(.success(testUser)))
    }
    
    func test_loginRequestEndWithError() {
        sut = .init(repository: .init(login: { _, _ in
            Just(.failure(.noUser))
                .eraseToAnyPublisher()
        }))
        
        spy.schedule(
            sut.reduce(&state, action: ._loginRequest)
        )
        
        XCTAssertEqual(spy.actions.count, 1)
        XCTAssertEqual(spy.actions.first, ._loginResponse(.failure(.noUser)))
    }
    
    func test_reduceFailedLoginRequest() {
        _ = sut.reduce(&state, action: ._loginResponse(.failure(.noUser)))
        
        XCTAssertTrue(state.isAlert)
        XCTAssertEqual(state.alertText, "noUser")
    }
    
    func test_reduceSuccessLoginRequest() {
        _ = sut.reduce(&state, action: ._loginResponse(.success(testUser)))
        
        XCTAssertTrue(state.isAlert)
        XCTAssertEqual(state.alertText, "Hello, \(testUser.firstName)!")
    }
    
}

private extension LoginDomainTests {
    func makeSUT(
        isCredValid: Bool = true,
        userResponse: Repository.Response<UserAccount> = .success(.sample)
    ) -> LoginDomain {
        .init(
            repository: .preview(userResponse: userResponse, delay: .zero),
            validateEmail: { _ in isCredValid },
            validatePassword: { _ in isCredValid }
        )
    }
}

