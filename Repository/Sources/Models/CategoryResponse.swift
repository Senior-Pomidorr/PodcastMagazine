//
//  CategoryResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

struct CategoryResponse: Decodable {
    let status: Bool
    let feeds: [Category]
    let count: Int
    let description: String
}
