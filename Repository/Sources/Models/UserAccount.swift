//
//  UserAccount.swift
//
//
//  Created by Илья Шаповалов on 24.09.2023.
//

import Foundation

public struct UserAccount: Equatable {
    public var imageUrl: String?
    public var firstName: String
    public var lastName: String
    public var email: String
    public var dateOfBirth: Date
    public var gender: Gender
    
    public init(
        imageUrl: String? = nil,
        firstName: String,
        lastName: String,
        email: String,
        dateOfBirth: Date = .init(),
        gender: Gender = .none
    ) {
        self.imageUrl = imageUrl
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
}

public extension UserAccount {
    enum Gender: String {
        case male
        case female
        case none
    }
}

