//
//  HomePageDomain.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import Foundation
import Models
import Combine
import Repository

// MARK: - HomePageLoadingStatus
enum HomePageLoadingStatus: Equatable {
    static func == (lhs: HomePageLoadingStatus, rhs: HomePageLoadingStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case none
    case loading
    case error(Error)
}

// MARK: - SelectedCategoryRequest
enum SelectedCategoryRequest: String, CaseIterable {
    case popular
    case recent
    case audiobook
    case film
    case music
    case video
}

struct HomePageDomain {
    // MARK: - State
    struct State: Equatable {
        var categoryList: [Models.Category]
        var podcastsList: [Feed]
        var homePageLoadingStatus: HomePageLoadingStatus
        var detailsPageLoadingStatus: HomePageLoadingStatus
        var feedsCategoryList: SelectedCategoryRequest
        var feedDetails: FeedDetail
        
        init(
            categoryList: [Models.Category] = .init(),
            podcastsList: [Feed] = .init(),
            homePageLoadingStatus: HomePageLoadingStatus = .none,
            detailsPageLoadingStatus: HomePageLoadingStatus = .none
        ) {
            self.categoryList = categoryList
            self.podcastsList = podcastsList
            self.homePageLoadingStatus = homePageLoadingStatus
            self.feedsCategoryList = .popular
            self.feedDetails = .sample
            self.detailsPageLoadingStatus = detailsPageLoadingStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case categoryCellDidTap
        case _getCategoryRequest
        case _getPodcastRequest
        case _getCategoryResponse(Repository.Response<CategoryResponse>)
        case _getPodcastsResponse(Repository.Response<FeedsResponse>)
        case getSelectedCategory(SelectedCategoryRequest)
        case getFeedDetails(Int)
        case _getFeedDetailsResponse(Repository.Response<FeedDetail>)
    }
    
    // MARK: - Dependencies
    
    let provider: HomeRepositoryProvider
    
    // MARK: - Reducer
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        switch action {
            
        case .viewAppeared:
            guard state.homePageLoadingStatus != .loading else { break }
            state.homePageLoadingStatus = .loading
            
            return Publishers.Merge(
                Just(._getCategoryRequest),
                Just(._getPodcastRequest)
            )
            .eraseToAnyPublisher()
            
            //   provider.getFeedRequest(.feeds(byTerm: "music"))
            //  provider.getFeedDetail(34534)
            
        case ._getCategoryRequest:
            return provider.getCategoryRequest()
                .map(Action._getCategoryResponse)
                .eraseToAnyPublisher()
            
        case ._getPodcastRequest:
            return provider.getFeedRequest(.trendingFeeds())
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
            
        case let ._getCategoryResponse(.success(response)):
            state.homePageLoadingStatus = .none
            state.categoryList = response.feeds
            print("!!!!!!!!!! --- category =", state.categoryList.count)
            
        case let ._getPodcastsResponse(.success(response)):
            state.homePageLoadingStatus = .none
            state.podcastsList = response.feeds
            print("!!!!!!!!!! --- podcast =", state.podcastsList.count)
            
        case let ._getCategoryResponse(.failure(error)), let ._getPodcastsResponse(.failure(error)):
            state.homePageLoadingStatus = .error(error)
            
        case .categoryCellDidTap:
            break
            
        case let .getSelectedCategory(selectedCategory):
            return fetchCategoryRequest(selected: selectedCategory)
            
        case let .getFeedDetails(feedId):
            return provider.getFeedDetail(feedId)
                .map(Action._getFeedDetailsResponse)
                .eraseToAnyPublisher()
            
        case let ._getFeedDetailsResponse(.success(feedDetail)):
            state.feedDetails = feedDetail
            
        case let ._getFeedDetailsResponse(.failure(error)):
            state.detailsPageLoadingStatus = .error(error)
        }
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchCategoryRequest(selected: SelectedCategoryRequest) -> AnyPublisher<Action, Never> {
        switch selected {
        case .popular:
            return provider.getFeedRequest(.trendingFeeds())
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        case .recent:
            return provider.getFeedRequest(.recentFeeds())
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        case .audiobook:
            return provider.getFeedRequest(.feeds(by: .audiobook))
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        case .film:
            return provider.getFeedRequest(.feeds(by: .film))
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        case .music:
            return provider.getFeedRequest(.feeds(by: .music))
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        case .video:
            return provider.getFeedRequest(.feeds(by: .video))
                .map(Action._getPodcastsResponse)
                .eraseToAnyPublisher()
        }
    }
    
    static let liveStore = HomePageStore(
        state: Self.State(),
        reducer: Self(provider: .live).reduce(_:with:)
    )
    
}

// MARK: - HomePageStore
final class HomePageStore: ObservableObject {
    @Published private(set) var state: HomePageDomain.State
    private let reducer: (inout HomePageDomain.State, HomePageDomain.Action) -> AnyPublisher<HomePageDomain.Action, Never>
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(
        state: HomePageDomain.State,
        reducer: @escaping (inout HomePageDomain.State, HomePageDomain.Action) -> AnyPublisher<HomePageDomain.Action, Never>
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: HomePageDomain.Action) {
        reducer(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancellable)
    }
}
