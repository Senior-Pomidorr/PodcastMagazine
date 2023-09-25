//
//  EpisodesResponse.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

struct EpisodesResponse: Decodable {
    let status: Bool
    
    /// List of live episodes for feed
    let liveItems: [Episode]?
    
    /// List of episodes matching request
    let items: [Episode]
    
    /// Number of items returned in request
    let count: Int
    
    /// Value of max parameter passed to request.
    let max: Int?
    
    /// Description of the response
    let description: String
}
