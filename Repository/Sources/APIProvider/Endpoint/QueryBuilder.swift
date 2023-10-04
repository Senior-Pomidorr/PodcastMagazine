//
//  QueryBuilder.swift
//  
//
//  Created by Илья Шаповалов on 04.10.2023.
//

import Foundation

@resultBuilder
enum QueryBuilder {
    static func buildOptional(_ component: [URLQueryItem]?) -> [URLQueryItem] {
        component ?? []
    }
    
    static func buildBlock(_ components: [URLQueryItem]...) -> [URLQueryItem] {
        components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: URLQueryItem) -> [URLQueryItem] {
        [expression]
    }
}
