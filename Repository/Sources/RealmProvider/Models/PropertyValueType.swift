//
//  PropertyValueType.swift
//
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation

public typealias PropertyValuePair = (name: String, value: Any)

public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}
