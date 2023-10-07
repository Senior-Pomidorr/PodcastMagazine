//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import Foundation
import Firebase

public extension FirebaseManager {
    enum FirebaseError: Error, LocalizedError {
        case logInFail(Error)
        case logOutFail(Error)
        case createUserFail(Error)
        case resetPasswordFail(Error)
        case noUser
        case unknown(Error)
        
        public var errorDescription: String? {
            String(describing: self)
        }
        
        static func map(_ error: Error) -> Self {
            error as? FirebaseError ?? .unknown(error)
        }
    }
}
