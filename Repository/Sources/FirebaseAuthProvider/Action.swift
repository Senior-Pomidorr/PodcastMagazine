//
//  Action.swift
//
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import Foundation

public extension FirebaseManager {
    enum Action {
        case logIn(email: String, password: String)
        case register(email: String, password: String)
        case currentUser
        case authState
    }
}
