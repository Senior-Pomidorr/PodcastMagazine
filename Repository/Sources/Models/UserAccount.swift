//
//  UserAccount.swift
//
//
//  Created by Илья Шаповалов on 24.09.2023.
//

import Foundation

public struct UserAccount {
    public let firstName: String
    public let lastName: String
    public let email: String
    public let password: String
    
    public init(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}
