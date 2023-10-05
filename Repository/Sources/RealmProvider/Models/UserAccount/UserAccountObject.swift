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
    @Persisted var imageUrl: String?
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var email: String
    @Persisted var dateOfBirth: Date
    @Persisted var gender: UserAccount.Gender
    
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
