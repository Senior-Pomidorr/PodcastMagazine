//
//  HomePageDomain.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import Foundation
import Models
import Combine

// MARK: - DataLoadingStatus
enum DataLoadingStatus: Equatable {
    static func == (lhs: DataLoadingStatus, rhs: DataLoadingStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case none
    case loading
    case error(Error)
}

// MARK: - State
private struct State: Equatable {
    var categoryList: [Models.Category]
    var podcastsList: [Feed]
    var dataLoadingStatus: DataLoadingStatus
    
    init(
        categoryList: [Models.Category] = .init(),
        podcastsList: [Feed] = .init(),
        dataLoadingStatus: DataLoadingStatus = .none
    ) {
        self.categoryList = categoryList
        self.podcastsList = podcastsList
        self.dataLoadingStatus = dataLoadingStatus
    }
}

// MARK: - Action
enum Action {
    case viewAppeared
    case categoryCellDidTap
    case seeAllButtonDidTap
    case _getCategoryRequest
    case _getPodcastRequest
    case _getCategoryResponse(Result<[Models.Category], Error>)
    case _getPodcastsResponse(Result<[Feed], Error>)
}

// MARK: - Dependencies
struct Dependencies {
    let getCategoryList: (String) -> AnyPublisher<[Models.Category], Error>
    let getPodcastsList: (String) -> AnyPublisher<[Feed], Error>
}

// MARK: - Reduce
fileprivate func reduce(
    _ state: inout State,
    with action: Action,
    env: Dependencies
) -> AnyPublisher<Action, Never> {
    switch action {
        
    case ._getCategoryRequest:
        return env.getCategoryList("categoryUrl")
            .map(toSuccessCategory(_:))
            .catch(toFailCategory(_:))
            .eraseToAnyPublisher()
        
    case ._getPodcastRequest:
        return env.getPodcastsList("podcastsUrl")
            .map(toSuccessFeed(_:))
            .catch(toFailFeed(_:))
            .eraseToAnyPublisher()
        
    case .viewAppeared:
        guard state.dataLoadingStatus != .loading else { break }
        state.dataLoadingStatus = .loading
        
        return Publishers.Merge(
            Just(._getCategoryRequest),
            Just(._getPodcastRequest)
        )
            .eraseToAnyPublisher()
        
    case let ._getCategoryResponse(.success(apiCategories)):
        state.dataLoadingStatus = .none
        state.categoryList = apiCategories
        
    case let ._getPodcastsResponse(.success(feeds)):
        state.dataLoadingStatus = .none
        state.podcastsList = feeds
        
    case let ._getCategoryResponse(.failure(error)), let ._getPodcastsResponse(.failure(error)):
        state.dataLoadingStatus = .error(error)
        
    case .categoryCellDidTap:
        break
        
    case .seeAllButtonDidTap:
        break

    }
    return Empty().eraseToAnyPublisher()
}

// MARK: - SuccessActionCategory
func toSuccessCategory(_ apiCategories: [Models.Category]) -> Action {
    ._getCategoryResponse(.success(apiCategories))
}

// MARK: - FailActionCategory
func toFailCategory(_ error: Error) -> Just<Action> {
    Just(._getCategoryResponse(.failure(error)))
}

// MARK: - SuccessActionFeed
func toSuccessFeed(_ feeds: [Feed]) -> Action {
    ._getPodcastsResponse(.success(feeds))
}

// MARK: - FailActionFeed
func toFailFeed(_ error: Error) -> Just<Action> {
    Just(._getPodcastsResponse(.failure(error)))
}
