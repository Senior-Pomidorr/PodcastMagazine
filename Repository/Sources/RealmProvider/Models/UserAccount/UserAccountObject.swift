//
//  UserAccountObject.swift
//
//
//  Created by Илья Шаповалов on 04.10.2023.
//

import Foundation
import RealmSwift
import Models

public final class UserAccountObject: Object, ObjectKeyIdentifiable {
    @Persisted public var imageUrl: String?
    @Persisted public var firstName: String
    @Persisted public var lastName: String
    @Persisted public var email: String
    @Persisted public var dateOfBirth: Date
    @Persisted public var gender: UserAccount.Gender
    
    public var id: String {
        email
    }
    
    public override class func primaryKey() -> String? {
        "email"
    }
    
    convenience init(userAccount: UserAccount) {
        self.init()
        self.imageUrl = userAccount.imageUrl
        self.firstName = userAccount.firstName
        self.lastName = userAccount.lastName
        self.email = userAccount.email
        self.dateOfBirth = userAccount.dateOfBirth
        self.gender = userAccount.gender
    }
}
