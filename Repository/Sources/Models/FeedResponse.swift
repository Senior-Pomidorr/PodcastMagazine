//
//  FeedResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

struct FeedResponse: Decodable {
    let status: Bool
    let feeds: [Feed]
    
    /// Number of items returned in request
    let count: Int
    
    /// Value of max parameter passed to request.
    let max: Int
    
    let description: String
}
