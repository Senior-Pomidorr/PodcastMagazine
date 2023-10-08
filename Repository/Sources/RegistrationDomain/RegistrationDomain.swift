//
//  RegistrationDomain.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import Foundation
import SwiftUDF
import Combine
import Models
import Repository
import Validator

public struct RegistrationDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        public var email: String
        public var firstName: String
        public var lastName: String
        public var password: String
        
        public var isEmailValid: Bool
        public var isPasswordValid: Bool
        public var completeAccountPresented: Bool
        
        //MARK: - init(_:)
        public init(
            email: String = .init(),
            firstName: String = .init(),
            lastName: String = .init(),
            password: String = .init(),
            isEmailValid: Bool = true,
            isPasswordValid: Bool = true,
            completeAccountPresented: Bool = false
        ) {
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.password = password
            self.isEmailValid = isEmailValid
            self.isPasswordValid = isPasswordValid
            self.completeAccountPresented = completeAccountPresented
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setEmail(String)
        case setFirstName(String)
        case setLastName(String)
        case setPassword(String)
        case continueButtonTap
        case dismissCompleteAccount
        case signUpButtonTap
        case _createNewUserRequest
        case _invalidCredentials
    }
    
    //MARK: - Dependencies
    private let validateEmail: (String) -> Bool
    private let validatePassword: (String) -> Bool
    
    //MARK: - init(_:)
    public init(
        validateEmail: @escaping (String) -> Bool = Validator.validate(email:),
        validatePassword: @escaping (String) -> Bool = Validator.validate(password:)
    ) {
        self.validateEmail = validateEmail
        self.validatePassword = validatePassword
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setEmail(email):
            switch email.isEmpty {
            case true:
                state.email = .init()
                state.isEmailValid = true
                
            case false:
                state.email = email
                state.isEmailValid = validateEmail(email)
            }
            
        case let .setPassword(password):
            switch password.isEmpty {
            case true:
                state.password = .init()
                state.isPasswordValid = true
                
            case false:
                state.password = password
                state.isPasswordValid = validatePassword(password)
            }
            
        case let .setFirstName(firstName):
            state.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            
        case let .setLastName(lastName):
            state.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .continueButtonTap:
            state.completeAccountPresented = true
            
        case .dismissCompleteAccount:
            state.completeAccountPresented = false
            
        case .signUpButtonTap:
            guard
                state.isEmailValid,
                state.isPasswordValid,
                !state.email.isEmpty,
                !state.password.isEmpty,
                !state.firstName.isEmpty,
                !state.lastName.isEmpty
            else {
                return run(._invalidCredentials)
            }
            return run(._createNewUserRequest)
            
        case ._invalidCredentials:
            break
            
        case ._createNewUserRequest:
            break
        }
        return empty()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
    
    //MARK: - Live store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
