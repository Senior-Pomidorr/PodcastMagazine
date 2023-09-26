//
//  HomePageDomain.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import Foundation
import Models
import Combine

// MARK: - HomePageLoadingStatus
private enum HomePageLoadingStatus: Equatable {
    static func == (lhs: HomePageLoadingStatus, rhs: HomePageLoadingStatus) -> Bool {
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
    var homePageLoadingStatus: HomePageLoadingStatus
    
    init(
        categoryList: [Models.Category] = .init(),
        podcastsList: [Feed] = .init(),
        homePageLoadingStatus: HomePageLoadingStatus = .none
    ) {
        self.categoryList = categoryList
        self.podcastsList = podcastsList
        self.homePageLoadingStatus = homePageLoadingStatus
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
        guard state.homePageLoadingStatus != .loading else { break }
        state.homePageLoadingStatus = .loading
        
        return Publishers.Merge(
            Just(._getCategoryRequest),
            Just(._getPodcastRequest)
        )
            .eraseToAnyPublisher()
        
    case let ._getCategoryResponse(.success(apiCategories)):
        state.homePageLoadingStatus = .none
        state.categoryList = apiCategories
        
    case let ._getPodcastsResponse(.success(feeds)):
        state.homePageLoadingStatus = .none
        state.podcastsList = feeds
        
    case let ._getCategoryResponse(.failure(error)), let ._getPodcastsResponse(.failure(error)):
        state.homePageLoadingStatus = .error(error)
        
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
