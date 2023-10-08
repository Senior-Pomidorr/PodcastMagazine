//
//  UserAccount.swift
//
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import Foundation
import FirebaseAuth
import Models

extension UserAccount {
    init(user: User) {
        self.init(
            firstName: user.displayName ?? .init(),
            lastName: .init(),
            email: user.email ?? .init()
        )
    }
    
    init(user: User?) throws {
        guard let user = user else {
            throw FirebaseManager.FirebaseError.noUser
        }
        self.init(user: user)
    }
}
