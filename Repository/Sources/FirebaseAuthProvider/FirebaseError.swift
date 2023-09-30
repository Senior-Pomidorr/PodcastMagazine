//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import Foundation

public extension FirebaseProvider {
    enum FirebaseError: Error, LocalizedError {
        case logInFail(Error)
        case logOutFail(Error)
        case createUserFail(Error)
        case noUser
        
        public var errorDescription: String? {
            String(describing: self)
        }
    }
}
