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
    
    public init(
        status: String,
        feeds: [Category],
        count: Int,
        description: String
    ) {
        self.status = status
        self.feeds = feeds
        self.count = count
        self.description = description
    }
    
    public static let sample = Self(
        status: "true",
        feeds: [.sample],
        count: 1,
        description: "Category response"
    )
}
