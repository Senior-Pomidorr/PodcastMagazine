//
//  SearchScreenDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation
import Models

enum ScreenStatus: Equatable {
    case none
    case loading
    case error(Error)
    
    static func == (lhs: ScreenStatus, rhs: ScreenStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

struct SearchDomain {
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
        case _topGenresResponce(Result<[Feed], Error>)
        case _allGenresResponce(Result<[Feed], Error>)
    }
    
    // MARK: - Dependencies
    let getTopGenres: (String) -> AnyPublisher<[Feed], Error>
    let getAllGenres: (String) -> AnyPublisher<[Feed], Error>
    
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
    
    
    func toSuccessTopGenres(_ genres: [Feed]) -> Action {
        ._topGenresResponce(.success(genres))
    }
    

    func toFailTopGenres(_ error: Error) -> Just<Action> {
        Just(._topGenresResponce(.failure(error)))
    }
    
    func toSuccessAllGenres(_ genres: [Feed]) -> Action {
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
    
    static var live = Self(
        getTopGenres: {_ in Empty().eraseToAnyPublisher() },
        getAllGenres: {_ in Empty().eraseToAnyPublisher() })
}
