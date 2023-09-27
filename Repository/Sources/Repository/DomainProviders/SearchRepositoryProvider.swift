//
//  SearchRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models
import Combine
import APIProvider

public struct SearchRepositoryProvider {
    public var getFeedsRequest: (Endpoint) -> Repository.ResponsePublisher<FeedResponse>
    
    public static var live: SearchRepositoryProvider {
        .init(getFeedsRequest: { Repository.shared.perform(request: .api($0)) })
    }
}
