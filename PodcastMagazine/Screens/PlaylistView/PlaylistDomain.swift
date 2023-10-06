//
//  PlaylistUDF.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 01.10.2023.
//

import Foundation
import Models
import Combine
import Repository

// MARK: - PlaylistStatus
enum PlaylistLoadingStatus: Equatable {
    static func == (lhs: PlaylistLoadingStatus, rhs: PlaylistLoadingStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case none
    case loading
    case error(Error)
}

struct PlayListDomain {
    
    // MARK: - PlaylistLive
    static let playlistDomainLive = PlaylistStore(
        state: State(),
        reducer: PlayListDomain(provider: .live)
    )
    
    // MARK: - State
    struct State: Equatable {
        var favoritesList: [Feed]
        var playlistList: [Playlist]
        var playlistStatus: PlaylistLoadingStatus
        
        init(
            favoritesList: [Feed] = .init(),
            playlistList: [Playlist] = .init(),
            playlistStatus: PlaylistLoadingStatus = .none,
            detailsPageLoadingStatus: PlaylistLoadingStatus = .none
        ) {
            self.favoritesList = favoritesList
            self.playlistList = playlistList
            self.playlistStatus = playlistStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppered
        case _getFavoritesListRequest
        case _getPlaylistRequest
        case _getFavoritesListResponse([Feed])
        case _getPlaylistResponse([Playlist])
    }
    
    // MARK: - Dependecies
    let provider: FavoritesAndPlaylistsRepositoryProvider
    
    // MARK: - Reducer
    func reduce(_ state: inout State, with action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .viewAppered:
            guard state.playlistStatus != .loading else { break }
            state.playlistStatus = .loading
            
            return Publishers.Merge(
                Just(._getFavoritesListRequest),
                Just(._getPlaylistRequest)
            )
            .eraseToAnyPublisher()
            
        case ._getFavoritesListRequest:
            return provider.getFavoritesFeeds()
                .map(Action._getFavoritesListResponse)
                .eraseToAnyPublisher()
            
        case let ._getFavoritesListResponse(favorites):
            state.playlistStatus = .none
            state.favoritesList = favorites
            
        case ._getPlaylistRequest:
            return provider.getPlaylists()
                .map(Action._getPlaylistResponse)
                .eraseToAnyPublisher()
            
        case let ._getPlaylistResponse(playlist):
            state.playlistStatus = .none
            state.playlistList = playlist
        }
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: -  PlaylistStore
final class PlaylistStore: ObservableObject {
    @Published private(set) var state: PlayListDomain.State
    private let reduce: PlayListDomain
    private var cancelleble: Set<AnyCancellable> = .init()
    
    init(
        state: PlayListDomain.State,
        reducer: PlayListDomain
    ) {
        self.state = state
        self.reduce = reducer
    }
    
    func send(_ action: PlayListDomain.Action) {
        reduce.reduce(&state, with: action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelleble)
    }
}
