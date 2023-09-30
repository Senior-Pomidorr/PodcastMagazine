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
        var textQuery: String
        var genres: [Feed]
        var podcasts: [Feed]
        var searchScreenStatus: ScreenStatus
        
        init(
            textQuery: String = .init(),
            genres: [Feed] = .init(),
            podcasts: [Feed] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.textQuery = textQuery
            self.genres = genres
            self.podcasts = podcasts
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case setQuery(String)
        case viewAppeared
        case _getQueryRequest
        case _getPodcastRequest
        case _queryResponce(Repository.Response<FeedsResponse>)
        case _podcastResponce(Repository.Response<FeedsResponse>)
    }
    
    // MARK: - Dependencies
    let provider: SearchRepositoryProvider
    
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

        case let .setQuery(query):
            state.textQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            
        case ._getQueryRequest:
            return provider.getFeedRequest(.feeds(byTerm: state.textQuery))
                .map(Action._queryResponce)
                .eraseToAnyPublisher()
            
        case ._getPodcastRequest:
            return provider.getFeedRequest(.trendingFeeds())
                .map(Action._podcastResponce)
                .eraseToAnyPublisher()
            
        case let ._queryResponce(.success(result)):
            state.searchScreenStatus = .none
            state.genres = result.feeds
            
        case let ._queryResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let ._podcastResponce(.success(result)):
            state.searchScreenStatus = .none
            state.podcasts = result.feeds
            
        case let ._podcastResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
