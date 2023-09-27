//
//  EpisodesResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct EpisodesResponse: Decodable {
    public let status: String
    
    /// List of live episodes for feed
    public let liveItems: [Episode]?
    
    /// List of episodes matching request
    public let items: [Episode]
    
    /// Number of items returned in request
    public let count: Int
    
    /// Value of max parameter passed to request.
    public let max: Int?
    
    /// Description of the response
    public let description: String
    
    public init(
        status: String,
        liveItems: [Episode]?,
        items: [Episode],
        count: Int,
        max: Int?,
        description: String
    ) {
        self.status = status
        self.liveItems = liveItems
        self.items = items
        self.count = count
        self.max = max
        self.description = description
    }
    
    public static let sample = Self(
        status: "true",
        liveItems: nil,
        items: [.sample],
        count: 1,
        max: nil,
        description: "Sample response"
    )
}
