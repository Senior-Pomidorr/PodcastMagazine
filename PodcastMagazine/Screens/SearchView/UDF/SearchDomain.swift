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
        var topGenres: [Feed]
        var allGenres: [Feed]
        var searchScreenStatus: ScreenStatus
        
        init(
            textQuery: String = .init(),
            topGenres: [Feed] = .init(),
            allGenres: [Feed] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.textQuery = textQuery
            self.topGenres = topGenres
            self.allGenres = allGenres
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case didTypeQuery(String)
        case _getTopRequest
        case _getAllRequest
        case _topGenresResponce(Repository.Response<FeedResponse>)
        case _allGenresResponce(Repository.Response<FeedResponse>)
    }
    
    // MARK: - Dependencies
    let provider: HomeRepositoryProvider
    let pr: SearchRepositoryProvider = .preview(.)
    // MARK: - reduce
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
                Just(._getAllRequest),
                Just(._getTopRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getTopRequest:
            return provider.getFeedRequest(.feeds(by: .audiobook, max: 30))
                .map(Action._topGenresResponce)
                .eraseToAnyPublisher()
            
        case ._getAllRequest:
            return provider.getFeedRequest(.feeds(by: .film, max: 20))
                .map(Action._allGenresResponce)
                .eraseToAnyPublisher()
            
        case let ._topGenresResponce(.success(result)):
            state.searchScreenStatus = .none
            state.topGenres = result.feeds
            
        case let ._topGenresResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let ._allGenresResponce(.success(result)):
            state.searchScreenStatus = .none
            state.allGenres = result.feeds
            
        case let ._allGenresResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let .didTypeQuery(result):
            state.textQuery = changeString(result)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    /// Изменения строки введеннкой в SearchBar
    /// - Parameter query: Строка введенная пользователем
    /// - Returns: String.trimmingCharacters(in: .whitespacesAndNewlines)
    func changeString(_ query: String) -> String {
        return query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
