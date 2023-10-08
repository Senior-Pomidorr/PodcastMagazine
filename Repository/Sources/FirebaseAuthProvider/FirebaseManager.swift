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
        case .authState:
            return authStatePublisher()
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
    
    /// Initiates a password reset for the given email address.
    ///
    /// The publisher will emit events on the **main** thread.
    ///
    /// - Parameter email: The email address of the user.
    /// - Returns: A publisher that emits whether the call was successful or not. The publisher will
    /// emit on the *main* thread.
    /// - Remark: Possible error codes:
    ///   - `AuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was sent in
    /// the request.
    ///   - `AuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in the console
    /// for this action.
    ///   - `AuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for sending
    /// update email.
    ///
    public func changePassword(email: String) -> AnyPublisher<Void, FirebaseError> {
        auth.sendPasswordReset(withEmail: email)
            .mapError(FirebaseError.resetPasswordFail)
            .eraseToAnyPublisher()
    }
    
}

private extension FirebaseManager {
    /// Signs in a user with the given email address and password.
    ///
    /// The publisher will emit events on the **main** thread.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A publisher that emits the result of the sign in flow. The publisher will emit on
    /// the *main* thread.
    /// - Remark:
    ///   Possible error codes:
    ///   - `AuthErrorCodeOperationNotAllowed` - Indicates that email and password
    ///     accounts are not enabled. Enable them in the Auth section of the
    ///     Firebase console.
    ///   - `AuthErrorCodeUserDisabled` - Indicates the user's account is disabled.
    ///   - `AuthErrorCodeWrongPassword` - Indicates the user attempted
    ///     sign in with an incorrect password.
    ///   - `AuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
    ///
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
    
    func authStatePublisher() -> AnyPublisher<UserAccount, FirebaseError> {
        auth.authStateDidChangePublisher()
            .tryMap(UserAccount.init)
            .mapError(FirebaseError.map(_:))
            .eraseToAnyPublisher()
    }
    
}
