//
//  CategoryResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct CategoryResponse: Decodable {
    public let status: String
    public let feeds: [Category]
    public let count: Int
    public let description: String
}
