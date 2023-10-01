//
//  FeedDetail.swift
//
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation

public struct FeedDetail: Decodable, Equatable {
    public let status: String
    public let feed: Feed
    public let description: String
    
    public init(
        status: String,
        feed: Feed,
        description: String
    ) {
        self.status = status
        self.feed = feed
        self.description = description
    }
    
    public static let sample = Self(
        status: "true",
        feed: .sample,
        description: "Feed response"
    )
}
