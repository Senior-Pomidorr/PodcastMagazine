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
}
