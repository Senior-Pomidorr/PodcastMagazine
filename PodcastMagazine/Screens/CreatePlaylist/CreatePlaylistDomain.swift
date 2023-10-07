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
        static func == (lhs: CreatePlaylistDomain.State, rhs: CreatePlaylistDomain.State) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        var userQuery: String
        var playlistStatus: PlaylistLoadingStatus
        var getEpisodesRequest: [Episode]
        var randomEpisodes: [Episode]
        var trimmingUserQuery: String {
            userQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        init(
            userQuery: String = .init(),
            playlistStatus: PlaylistLoadingStatus = .none,
            getEpisodesRequest: [Episode] = .init(),
            randomEpisodes: [Episode] = .init()
        ) {
            self.userQuery = userQuery
            self.playlistStatus = playlistStatus
            self.getEpisodesRequest = getEpisodesRequest
            self.randomEpisodes = randomEpisodes
        }
    }
    
    //MARK: - Action
    enum Action {
        case viewAppeared
        case _getQueryRequest
        case _getQueryResponse(Repository.Response<EpisodesResponse>)
        case _getRandomEpisodesRequest
        case _getEpisodesResponse(Repository.Response<EpisodesResponse>)
        case episodesCellDidTap(Repository.Response<Episode>)
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
            return provider.getEpisodes(.randomEpisodes(max: 20))
                .map(Action._getEpisodesResponse)
                .eraseToAnyPublisher()
            
        case let ._getEpisodesResponse(.success(result)):
            state.playlistStatus = .none
            state.randomEpisodes = result.items
            
        case let ._getEpisodesResponse(.failure(error)):
            state.playlistStatus = .error(error)
            
        case ._getQueryRequest:
            return provider.getEpisodes(.feeds(byTitle: state.trimmingUserQuery))
                .map(Action._getQueryResponse)
                .eraseToAnyPublisher()
            
        case let ._getQueryResponse(.success(result)):
            state.playlistStatus = .none
            state.getEpisodesRequest = result.items
            
        case let  ._getQueryResponse(.failure(error)):
            state.playlistStatus = .error(error)
            
        case .episodesCellDidTap(_):
            break
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


