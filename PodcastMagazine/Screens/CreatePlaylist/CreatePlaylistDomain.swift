//
//  CreatePlaylistDomain.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 02.10.2023.
//

import Foundation
import Models
import Combine
import Repository

//MARK: State
struct CreatePlaylistDomain {
    
    static let createPlaylistLive = CreatePlaylistStore(
        state: Self.State(),
        reducer: Self.reduce(Self.init(provider: FavoritesAndPlaylistsRepositoryProvider.live))
    )
    
    struct State: Equatable {
        static func == (lhs: CreatePlaylistDomain.State, rhs: CreatePlaylistDomain.State) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        var greateNamePlaylist: String
        var favoritesEpisodes: [Episode]
        var createPlaylistStatus: PlaylistLoadingStatus
        var searchQuery: String
        var feed: [Feed]?
        var episodesFeed: [EpisodesResponse]
        
        init(
            favoritesEpisodes: [Episode] = .init(),
            createPlaylistStatus: PlaylistLoadingStatus = .none,
            searchQuery: String = .init(),
            feed: [Feed]? = nil,
            episodesFeed: [EpisodesResponse] = .init(),
            createNamePlaylist: String = .init()
        ) {
            self.greateNamePlaylist = createNamePlaylist
            self.favoritesEpisodes = favoritesEpisodes
            self.createPlaylistStatus = createPlaylistStatus
            self.searchQuery = searchQuery
            self.feed = feed
            self.episodesFeed = episodesFeed
        }
    }
    
    enum Action {
        case viewAppeared
        case addPlaylistDidTap(String)
        case episodesCellDidTap(Repository.Response<Episode>)
        case _getEpisodesRequest
        case _getPocdastsRequest
        case _getEpisodesResponse(Repository.Response<EpisodesResponse>)
        case _getPodcastsResponse([Feed])
    }
    
    let provider: FavoritesAndPlaylistsRepositoryProvider
    
    func reduce(_ state: inout State, with action: Action) -> AnyPublisher<Action, Never> {
        switch action {
            
        case .viewAppeared:
            guard state.createPlaylistStatus != .loading else { break }
            state.createPlaylistStatus = .loading
            return Publishers.Merge(
                Just(._getEpisodesRequest),
                Just(._getPocdastsRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getEpisodesRequest:
            return provider.getEpisodes(.randomEpisodes(max: 20))
            .map(Action._getEpisodesResponse)
            .eraseToAnyPublisher()
            
        case let ._getEpisodesResponse(.success(result)):
            state.createPlaylistStatus = .none
            state.favoritesEpisodes = result.items
            
        case let ._getEpisodesResponse(.failure(error)):
            state.createPlaylistStatus = .error(error)
            
//        case ._getPocdastsRequest:
//            return provider
//                .map(Action.)
//                .eraseToAnyPublisher()
//            
        case ._getPodcastsResponse(_):
            break
            
        case .addPlaylistDidTap(_):
            break
        case .episodesCellDidTap(_):
            break
    
       
        
        case ._getPocdastsRequest:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

final class CreatePlaylistStore: ObservableObject {
    @Published private(set) var state: CreatePlaylistDomain.State
    private let reducer: (inout CreatePlaylistDomain.State, CreatePlaylistDomain.Action) -> AnyPublisher<CreatePlaylistDomain.Action, Never>
    private var cancellbale: Set<AnyCancellable> = .init()
    
    init(
        state: CreatePlaylistDomain.State,
        reducer: @escaping (inout CreatePlaylistDomain.State, CreatePlaylistDomain.Action) -> AnyPublisher<CreatePlaylistDomain.Action, Never>
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: CreatePlaylistDomain.Action) {
        reducer(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancellbale)
    }
}


