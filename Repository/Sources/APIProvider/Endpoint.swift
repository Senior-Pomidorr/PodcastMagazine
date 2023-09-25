//
//  Endpoint.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    //MARK: - URL
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.podcastindex.org"
        components.path = ["/api/1.0/", path].joined()
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            preconditionFailure("Unable to create url from: \(components)")
        }
        return url
    }
    
    //MARK: - init(_:)
    init(
        path: String,
        queryItems: [URLQueryItem] = .init()
    ) {
        self.path = path
        self.queryItems = queryItems
    }
    
    //MARK: - Endpoints
    
    /// Return all the possible categories supported by the index. Return `CategoryResponse` model.
    static let categories = Self(path: "categories/list")
    
    
    /// This call returns all the episodes we know about for this feed from the PodcastIndex ID. Episodes are in reverse chronological order.
    /// - Parameters:
    ///   - feedId: The internal PodcastIndex.org Feed ID.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `EpisodesResponse` model
    static func episodes(
        by feedId: Int,
        max: Int = 20
    ) -> Self {
        .init(
            path: "episodes/byfeedid",
            queryItems: [
                .init(name: "id", value: feedId.description)
            ]
        )
    }
    
    
}
