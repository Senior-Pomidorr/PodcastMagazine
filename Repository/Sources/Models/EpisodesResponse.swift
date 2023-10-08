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
    
    enum CodingKeys: CodingKey {
        case status
        case liveItems
        case items
        case count
        case max
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.liveItems = try container.decodeIfPresent([Episode].self, forKey: .liveItems)
        self.items = try container.decodeIfPresent([Episode].self, forKey: .items) ?? []
        self.count = try container.decode(Int.self, forKey: .count)
        self.max = try container.decodeIfPresent(Int.self, forKey: .max)
        self.description = try container.decode(String.self, forKey: .description)
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
