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

public struct AuthorizationDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        public var email: String
        public var password: String
        
        public init(
            email: String = .init(),
            password: String = .init()
        ) {
            self.email = email
            self.password = password
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setEmail(String)
        case setPassword(String)
    }
    
    //MARK: - Dependencies
    private let repository: AuthorizationRepositoryProvider
    private let emailValidation: (String) -> Bool
    
    //MARK: - init(_:)
    public init(
        repository: AuthorizationRepositoryProvider = .live,
        emailValidation: @escaping (String) -> Bool = { _ in true }
    ) {
        self.repository = repository
        self.emailValidation = emailValidation
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .setEmail(let email):
            state.email = email
            
        case .setPassword(let password):
            state.password = password
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
