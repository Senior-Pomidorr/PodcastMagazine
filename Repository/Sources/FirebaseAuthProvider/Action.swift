//
//  Action.swift
//
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import Foundation

public extension FirebaseProvider {
    enum Action {
        case logIn(email: String, password: String)
        case register(email: String, password: String)
        case currentUser
    }
}
