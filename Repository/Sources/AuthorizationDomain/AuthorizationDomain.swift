//
//  AuthorizationDomain.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation
import Repository
import SwiftUDF
import Combine
import Models

public struct AuthorizationDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        public var email: String
        public var password: String
        public var alertText: String
        public var isEmailValid: Bool
        public var isPasswordValid: Bool
        public var isAlert: Bool
        
        public var isLoginButtonActive: Bool {
            guard
                !email.isEmpty,
                !password.isEmpty,
                isEmailValid,
                isPasswordValid
            else {
                return false
            }
            
            return true
        }
        
        //MARK: - init(_:)
        public init(
            email: String = .init(),
            password: String = .init(),
            errorDescription: String = .init(),
            isEmailValid: Bool = true,
            isPasswordValid: Bool = true,
            isError: Bool = false
        ) {
            self.email = email
            self.password = password
            self.alertText = errorDescription
            self.isEmailValid = isEmailValid
            self.isPasswordValid = isPasswordValid
            self.isAlert = isError
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setEmail(String)
        case setPassword(String)
        case loginButtonTap
        case _loginRequest
        case _loginResponse(Repository.Response<UserAccount>)
    }
    
    //MARK: - Dependencies
    private let repository: AuthorizationRepositoryProvider
    private let validateEmail: (String) -> Bool
    private let validatePassword: (String) -> Bool
    
    //MARK: - init(_:)
    public init(
        repository: AuthorizationRepositoryProvider = .live,
        validateEmail: @escaping (String) -> Bool = Validator.validate(email:),
        validatePassword: @escaping (String) -> Bool = Validator.validate(password:)
    ) {
        self.repository = repository
        self.validateEmail = validateEmail
        self.validatePassword = validatePassword
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .setEmail(let email):
            switch email.isEmpty {
            case true:
                state.email = .init()
                state.isEmailValid = true
                
            case false:
                state.email = email
                state.isEmailValid = validateEmail(email)
            }
            
        case .setPassword(let password):
            switch password.isEmpty {
            case true:
                state.password = .init()
                state.isPasswordValid = true
                
            case false:
                state.password = password
                state.isPasswordValid = validatePassword(password)
            }
            
        case .loginButtonTap:
            return run(._loginRequest)
            
        case ._loginRequest:
            return repository.login(
                state.email,
                state.password
            )
            .map(Action._loginResponse)
            .eraseToAnyPublisher()
            
        case let ._loginResponse(.success(user)):
            state.isAlert = true
            state.alertText = "Hello, \(user.firstName)!"
            
        case let ._loginResponse(.failure(error)):
            state.isAlert = true
            state.alertText = error.errorDescription
            
        }
        
        return empty()
    }
    
    //MARK: - previewStore
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self(
            repository: .preview()
        )
    )
}
