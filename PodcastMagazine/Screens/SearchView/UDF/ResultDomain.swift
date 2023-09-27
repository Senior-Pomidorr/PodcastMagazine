//
//  SearchScreenResultDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation
import Models


struct ResultDomain {
    // MARK: - State
    struct State {
        var textQuery: String
        var genres: [Feed]
        var searchScreenStatus: ScreenStatus
        
        init(
            textQuery: String = .init(),
            allGenres: [Feed] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.textQuery = textQuery
            self.genres = allGenres
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case _getQueryRequest
        case _queryResponce(Result<[Feed], Error>)
    }
    
    // MARK: - Dependencies
    let getQueryGenres: (String) -> AnyPublisher<[Feed], Error>
    
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
            return Just(._getQueryRequest)
                .eraseToAnyPublisher()
            
        case ._getQueryRequest:
            return getQueryGenres("url")
                .map(toSuccess(_:))
                .catch(toFail(_:))
                .eraseToAnyPublisher()
            
        case let ._queryResponce(.success(result)):
            state.searchScreenStatus = .none
            state.genres = result
            
        case let ._queryResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    func toSuccess(_ genres: [Feed]) -> Action {
        ._queryResponce(.success(genres))
    }
    
    func toFail(_ error: Error) -> Just<Action> {
        Just(._queryResponce(.failure(error)))
    }
    
    static var live = Self(
        getQueryGenres: {_ in Empty().eraseToAnyPublisher() })
}
