//
//  Category.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct Category: Identifiable, Decodable {
    public let id: Int
    public let name: String
    
    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    public static let sample: Category = .init(
        id: 2,
        name: "Books"
    )
}
