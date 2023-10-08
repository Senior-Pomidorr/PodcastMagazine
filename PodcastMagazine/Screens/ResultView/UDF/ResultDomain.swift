//
//  SearchScreenResultDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation
import Models
import Repository


struct ResultDomain {
    static let liveStore = ResultStore(
        state: Self.State(),
        reduser: Self.reduce(.init(provider: .live))
    )
    
    // MARK: - State
    struct State {
        var userQuery: String
        var genres: [Feed]
        var podcasts: [Feed]
        var searchScreenStatus: ScreenStatus
        
        var trimmingUserQuery: String {
            userQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // MARK: - init(:)
        init(
            query: String = .init(),
            genres: [Feed] = .init(),
            podcasts: [Feed] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.userQuery = query
            self.genres = genres
            self.podcasts = podcasts
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case _getQueryRequest
        case _getPodcastRequest
        case _queryResponse(Repository.Response<FeedsResponse>)
        case _podcastResponse(Repository.Response<FeedsResponse>)
    }
    
    // MARK: - Dependencies
    let provider: SearchRepositoryProvider
    
    // MARK: - func reduce
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .viewAppeared:
            guard state.searchScreenStatus != .loading else {
                break
            }
            
            state.searchScreenStatus = .loading
            
            return Publishers.Merge(
                Just(._getQueryRequest),
                Just(._getPodcastRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getQueryRequest:
            return provider.getFeedRequest(.feeds(byTitle: state.trimmingUserQuery))
                .map(Action._queryResponse)
                .eraseToAnyPublisher()
            
        case ._getPodcastRequest:
            return provider.getFeedRequest(.trendingFeeds())
                .map(Action._podcastResponse)
                .eraseToAnyPublisher()
            
        case let ._queryResponse(.success(result)):
            state.searchScreenStatus = .none
            if result.feeds.isEmpty {
                state.genres = fakeFeed()
            } else {
                state.genres = result.feeds
            }
            
        case let ._queryResponse(.failure(error)):
            state.searchScreenStatus = .error(error)

            
        case let ._podcastResponse(.success(result)):
            state.searchScreenStatus = .none
            state.podcasts = result.feeds
            
        case let ._podcastResponse(.failure(error)):
            state.searchScreenStatus = .error(error)
            state.genres = fakeFeed()
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    func fakeFeed() -> [Feed] {
        return [Feed(id: 0, url: "", title: "No result", description: "", image: nil, author: nil, ownerName: nil, artwork: nil, language: "", medium: nil, episodeCount: nil, categories: nil)]
    }
}
