//
//  SearchScreenDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation

enum ScreenStatus: Equatable {
    case none
    case loading
    case error(Error)
    
    static func == (lhs: ScreenStatus, rhs: ScreenStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

struct MocGenre: Equatable { }

struct SearchScreenDomain {
    
    struct State: Equatable {
        var textQuery: String
        var topGenres: [MocGenre]
        var allGenres: [MocGenre]
        var searchScreenStatus: ScreenStatus
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case didTypeQuery(String)
        case _getTopRequest
        case _getAllRequest
        case _topGenresResponce(Result<[MocGenre], Error>)
        case _allGenresResponce(Result<[MocGenre], Error>)
    }
    
    // MARK: - Dependencies
    let getTopGenres: (String) -> AnyPublisher<[MocGenre], Error>
    let getAllGenres: (String) -> AnyPublisher<[MocGenre], Error>
    
    // MARK: - reduce
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .viewAppeared:
            state.searchScreenStatus = .loading
            return Publishers.Merge(
                Just(._getAllRequest),
                Just(._getTopRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getTopRequest:
            return getTopGenres("url")
                .map(toSuccessTopGenres(_:))
                .catch(toFailTopGenres(_:))
                .eraseToAnyPublisher()
            
        case ._getAllRequest:
            return getAllGenres("url")
                .map(toSuccessAllGenres(_:))
                .catch(toFailAllGenres(_:))
                .eraseToAnyPublisher()
            
        case let ._topGenresResponce(.success(result)):
            state.searchScreenStatus = .none
            state.topGenres = result
            
        case let ._topGenresResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let ._allGenresResponce(.success(result)):
            state.searchScreenStatus = .none
            state.allGenres = result
            
        case let ._allGenresResponce(.failure(error)):
            state.searchScreenStatus = .error(error)
            
        case let .didTypeQuery(result):
            state.textQuery = changeString(result)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    
    func toSuccessTopGenres(_ genres: [MocGenre]) -> Action {
        ._topGenresResponce(.success(genres))
    }
    

    func toFailTopGenres(_ error: Error) -> Just<Action> {
        Just(._topGenresResponce(.failure(error)))
    }
    
    func toSuccessAllGenres(_ genres: [MocGenre]) -> Action {
        ._allGenresResponce(.success(genres))
    }
    
    func toFailAllGenres(_ error: Error) -> Just<Action> {
        Just(._allGenresResponce(.failure(error)))
    }
    
    /// Изменения строки введеннкой в SearchBar
    /// - Parameter query: Строка введенная пользователем
    /// - Returns: String.trimmingCharacters(in: .whitespacesAndNewlines)
    func changeString(_ query: String) -> String {
        return query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
