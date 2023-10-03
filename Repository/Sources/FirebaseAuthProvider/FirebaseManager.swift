//
//  FirebaseProvider.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine
import Models

public struct FirebaseManager {
    private let auth: Auth
    
    //MARK: - init(_:)
    public init() {
        self.auth = Auth.auth()
    }
    
    //MARK: - Public methods
    public func perform(_ action: Action) -> AnyPublisher<UserAccount, FirebaseError> {
        switch action {
        case let .logIn(email, password):
            return signItWith(email: email, password: password)
        case let .register(email, password):
            return createUserWith(email: email, password: password)
        case .currentUser:
            return currentUserPublisher()
        }
    }
    
    public func logOut() -> AnyPublisher<Void, FirebaseError> {
        Deferred { [auth] in
            Future { promise in
                do {
                    try auth.signOut()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .mapError(FirebaseError.logOutFail)
        .eraseToAnyPublisher()
    }
    
}

private extension FirebaseManager {
    func signItWith(email: String, password: String) -> AnyPublisher<UserAccount, FirebaseError> {
        auth.signIn(withEmail: email, password: password)
            .map(\.user)
            .map(UserAccount.init)
            .mapError(FirebaseError.logInFail)
            .eraseToAnyPublisher()
    }
    
    func singInWith(_ credential: AuthCredential) -> AnyPublisher<UserAccount, FirebaseError> {
        auth.signIn(with: credential)
            .map(\.user)
            .map(UserAccount.init)
            .mapError(FirebaseError.logInFail)
            .eraseToAnyPublisher()
    }
    
    func createUserWith(email: String, password: String) -> AnyPublisher<UserAccount, FirebaseError> {
        auth.createUser(withEmail: email, password: password)
            .map(\.user)
            .map(UserAccount.init)
            .mapError(FirebaseError.createUserFail)
            .eraseToAnyPublisher()
    }
    
    func changePassword(email: String) {
        auth.sendPasswordReset(withEmail: email)
    }
    
    func currentUserPublisher() -> AnyPublisher<UserAccount, FirebaseError> {
        Deferred { [auth] in
            Future<User, FirebaseError> { promise in
                guard let user = auth.currentUser else {
                    promise(.failure(FirebaseError.noUser))
                    return
                }
                promise(.success(user))
            }
        }
        .map(UserAccount.init)
        .eraseToAnyPublisher()
    }
    
}
