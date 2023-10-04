//
//  RepositoryError.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import APIProvider
import FirebaseAuthProvider

public extension Repository {
    enum RepositoryError: Error, LocalizedError {
        case urlError(URLError)
        case decodingError(DecodingError)
        case unknown(Error)
        case invalidRequest(String)
        case loginError(Error)
        case logOutError(Error)
        case createUserError(Error)
        case noUser
        case realmUnavailable
        
        public var errorDescription: String { String(describing: self) }
        
        init(apiError: APIManager.APIError) {
            switch apiError {
            case .urlError(let urlError): self = .urlError(urlError)
            case .decodingError(let decodingError): self = .decodingError(decodingError)
            case .unknown(let error): self = .unknown(error)
            case .invalidRequest(let string): self = .invalidRequest(string)
            }
        }
        
        init(firebaseError: FirebaseManager.FirebaseError) {
            switch firebaseError {
            case .logInFail(let error): self = .loginError(error)
            case .logOutFail(let error): self = .logOutError(error)
            case .createUserFail(let error): self = .createUserError(error)
            case .noUser: self = .noUser
            }
        }
    }
}
