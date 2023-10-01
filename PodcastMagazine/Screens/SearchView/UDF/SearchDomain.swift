//
//  SearchScreenDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation
import Models
import Repository

enum ScreenStatus: Equatable {
    case none
    case loading
    case error(Error)
    
    static func == (lhs: ScreenStatus, rhs: ScreenStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

struct SearchDomain {
    // MARK: - StoreLive
    static let searchStoreLive = SearchStore(
        state: Self.State(),
        reduser: Self.reduce(Self.init(provider: HomeRepositoryProvider.live))
    )
    
    // MARK: - State
    struct State {
        var textQuery: String
        var trendPodcasts: [Feed]
        var categories: [Models.Category]
        var searchScreenStatus: ScreenStatus
        
        // MARK: - init(:)
        init(
            textQuery: String = .init(),
            trendPodcasts: [Feed] = .init(),
            categories: [Models.Category] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.textQuery = textQuery
            self.trendPodcasts = trendPodcasts
            self.categories = categories
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case _getTrendRequest
        case _getCategoryRequest
        case _trendResponce(Repository.Response<FeedsResponse>)
        case _categoryResponce(Repository.Response<CategoryResponse>)
    }
    
    // MARK: - Dependencies
    let provider: HomeRepositoryProvider

    // MARK: - func reduce
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .viewAppeared:
            // Проверка чтоб не повторять запрос
            guard state.searchScreenStatus != .loading else {
                break
            }
            state.searchScreenStatus = .loading
            return Publishers.Merge(
                Just(._getCategoryRequest),
                Just(._getTrendRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getTrendRequest:
            return provider.getFeedRequest(.trendingFeeds(max: 10))
                .map(Action._trendResponce)
                .eraseToAnyPublisher()
            
        case ._getCategoryRequest:
            return provider.getCategoryRequest()
                .map(Action._categoryResponce)
                .eraseToAnyPublisher()
            
        case let ._trendResponce(.success(result)):
            state.searchScreenStatus = .none
            state.trendPodcasts = result.feeds
            
        case let ._trendResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let ._categoryResponce(.success(result)):
            state.searchScreenStatus = .none
            state.categories = result.feeds
            
        case let ._categoryResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
