//
//  Persistable.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object, Identifiable
    associatedtype PropertyValue: PropertyValueType
    
    init(_ managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
