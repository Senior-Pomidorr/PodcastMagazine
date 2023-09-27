//
//  FeedResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct FeedResponse: Decodable {
    public let status: String
    public let feeds: [Feed]
    
    /// Number of items returned in request
    public let count: Int
       
    public let description: String
}
