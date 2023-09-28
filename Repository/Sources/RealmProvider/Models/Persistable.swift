//
//  Persistable.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    associatedtype PropertyValue: PropertyValueType
    
    init(_ managedObject: ManagedObject) throws
    func managedObject() -> ManagedObject
}
