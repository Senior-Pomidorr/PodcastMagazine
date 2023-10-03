//
//  PodcastDescriptionDomain.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 3.10.23.
//

import Foundation
import Models
import Combine
import Repository

struct PodcastDescriptionDomain {
    // MARK: - State
    struct State: Equatable {
        var pageLoadingStatus: HomePageLoadingStatus
        var feedDetail: FeedDetail
        var episodeList: [Episode]
        var podcastId: Int
        
        init(
            pageLoadingStatus: HomePageLoadingStatus = .none,
            feedDetail: FeedDetail = .sample,
            episodeList: [Episode] = .init(),
            podcastId: Int = 0
        ) {
            self.pageLoadingStatus = pageLoadingStatus
            self.feedDetail = feedDetail
            self.episodeList = episodeList
            self.podcastId = podcastId
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared(Int)
        case _getFeedDetail(Int)
        case _getFeedResponse(Repository.Response<FeedDetail>)
        case _getEpisodeList(Int)
        case _getEpisodeResponce(Repository.Response<EpisodesResponse>)
    }
    
    // MARK: - Dependencies
    
    let provider: HomeRepositoryProvider
    
    // MARK: - Reducer
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        switch action {
            
        case let .viewAppeared(id):
            return Publishers.Merge(
                Just(._getFeedDetail(id)),
                Just(._getEpisodeList(id))
            )
            .eraseToAnyPublisher()
            
        case let ._getFeedDetail(feedId):
            return provider.getFeedDetail(feedId)
                .map(Action._getFeedResponse)
                .eraseToAnyPublisher()
            
        case let ._getFeedResponse(.success(feed)):
            state.feedDetail = feed
            
        case ._getFeedResponse(.failure(_)):
            break
            
        case let ._getEpisodeList(feedId):
            return provider.getEpisodes(feedId)
                .map(Action._getEpisodeResponce)
                .eraseToAnyPublisher()
            
        case let ._getEpisodeResponce(.success(episodes)):
            state.episodeList = episodes.items
            
        case ._getEpisodeResponce(.failure(_)):
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    // MARK: - LiveViewInit
    static let liveStore = PodcastDescriptionStore (
        state: Self.State(),
        reducer: Self(provider: .live).reduce(_:with:)
    )
}

// MARK: - PodcastDescriptionStore
final class PodcastDescriptionStore: ObservableObject {
    @Published private(set) var state: PodcastDescriptionDomain.State
    private let reducer: (inout PodcastDescriptionDomain.State, PodcastDescriptionDomain.Action) -> AnyPublisher<PodcastDescriptionDomain.Action, Never>
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(
        state: PodcastDescriptionDomain.State,
        reducer: @escaping (inout PodcastDescriptionDomain.State, PodcastDescriptionDomain.Action) -> AnyPublisher<PodcastDescriptionDomain.Action, Never>
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: PodcastDescriptionDomain.Action) {
        reducer(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancellable)
    }
}
