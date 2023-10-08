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
        
        //MARK: - init(_:)
        public init(
            email: String = .init()
        ) {
            self.email = email
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setEmail(String)
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
