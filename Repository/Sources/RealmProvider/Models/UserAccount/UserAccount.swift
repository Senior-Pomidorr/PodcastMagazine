//
//  UserAccount.swift
//
//
//  Created by Илья Шаповалов on 04.10.2023.
//

import Foundation
import Models
import RealmSwift

extension UserAccount: Persistable {
    public typealias ManagedObject = UserAccountObject
    
    //MARK: - PropertyValue
    public enum PropertyValue: PropertyValueType {
        case imageUrl(String)
        case firstName(String)
        case lastName(String)
        case email(String)
        case dateOfBirth(Date)
        case gender(Gender)
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case .imageUrl(let imageUrl): return ("imageUrl", imageUrl)
            case .firstName(let name): return ("firstName", name)
            case .lastName(let lastName): return ("lastName", lastName)
            case .email(let email): return ("email", email)
            case .dateOfBirth(let date): return ("dateOfBirth", date)
            case .gender(let gender): return ("gender", gender)
            }
        }
    }
    
    public init(_ managedObject: UserAccountObject) {
        self.init(
            imageUrl: managedObject.imageUrl,
            firstName: managedObject.firstName,
            lastName: managedObject.lastName,
            email: managedObject.email,
            dateOfBirth: managedObject.dateOfBirth,
            gender: managedObject.gender
        )
    }
    
    public func managedObject() -> UserAccountObject {
        UserAccountObject(userAccount: self)
    }
}

extension UserAccount.Gender: PersistableEnum {
    public static var allCases: [UserAccount.Gender] {
        var arr = [UserAccount.Gender]()
        arr.append(.female)
        arr.append(.male)
        arr.append(.none)
        return arr
    }
}
