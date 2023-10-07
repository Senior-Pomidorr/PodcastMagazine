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



//MARK: - CreatePlaylistDomain
struct CreatePlaylistDomain {
    
    //MARK: - CreatePlaylistLive
    static let createPlaylistLive = CreatePlaylistStore (
        state: Self.State(),
        reducer: Self.reduce(Self.init(provider: FavoritesAndPlaylistsRepositoryProvider.live))
    )
    //MARK: - State
    struct State: Equatable {
        
        var userQuery: String
        var playlistStatus: PlaylistLoadingStatus
        var randomEpisodes: [Episode]
    
        init(
            userQuery: String = .init(),
            playlistStatus: PlaylistLoadingStatus = .none,
            randomEpisodes: [Episode] = .init()
        ) {
            self.userQuery = userQuery
            self.playlistStatus = playlistStatus
            self.randomEpisodes = randomEpisodes
        }
    }
    
    //MARK: - Action
    enum Action {
        case viewAppeared
        case setUserQuery(String)
        case getSearchRequest
        case _getSearchResponse(Repository.Response<EpisodesResponse>)
        case _getRandomEpisodesRequest
        case _getEpisodesResponse(Repository.Response<EpisodesResponse>)
//        case episodesCellDidTap(Repository.Response<Episode>)
    }
    
    let provider: FavoritesAndPlaylistsRepositoryProvider
    
    func reduce(_ state: inout State, with action: Action) -> AnyPublisher<Action, Never> {
        switch action {
            
        case .viewAppeared:
            guard state.playlistStatus != .loading else { break }
            state.playlistStatus = .loading
            return Just(._getRandomEpisodesRequest)
                .eraseToAnyPublisher()
            
        case ._getRandomEpisodesRequest:
            return provider.getEpisodes(.randomEpisodes(max: 10))
                .map(Action._getEpisodesResponse)
                .eraseToAnyPublisher()
            
        case let ._getEpisodesResponse(.success(result)):
            state.playlistStatus = .none
            state.randomEpisodes = result.items
            
        case let ._getEpisodesResponse(.failure(error)):
            state.playlistStatus = .error(error)
            
        case .getSearchRequest:
            state.playlistStatus = .loading
            return provider.getEpisodes(
                .episodes(
                    by: state.userQuery.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            )

                .map(Action._getSearchResponse)
                .eraseToAnyPublisher()
            
        case let ._getSearchResponse(.success(result)):
            state.playlistStatus = .none
            state.randomEpisodes = result.items
            
        case let  ._getSearchResponse(.failure(error)):
            state.playlistStatus = .error(error)
            
        case let .setUserQuery(query):
            state.userQuery = query
        }
        return Empty().eraseToAnyPublisher()
    }
    
}
//MARK: - CreatePlaylistStore
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


