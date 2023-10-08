//
//  SmallPlayerDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 08.10.23.
//

import AVKit
import Combine
import Foundation
import Models

// MARK: - SmallPlayerDomain
struct SmallPlayerDomain {
    static let live = SmallPlayerStore(
        state: Self.State(),
        reducer: Self()
    )
    
    enum SmallPlayerViewStatus {
        case none
        case loading
    }
    
    // MARK: - State
    struct State {
        var title: String
        var imageUrl: String
        var smallPlayerViewStatus: SmallPlayerViewStatus
        var isPlaying: Bool
        var isShowingSmallPlayer: Bool
        
        func createUrl(from episode: Episode?) -> URL? {
            guard let url = episode.map(\.enclosureUrl) else { return nil }
            return URL(string: url)
        }
        
        init(
            title: String = .init(),
            imageUrl: String = .init(),
            smallPlayerViewStatus: SmallPlayerViewStatus = .none,
            isPlaying: Bool = false,
            isShowingSmallPlayer: Bool = false
        ) {
            self.title = title
            self.imageUrl = imageUrl
            self.smallPlayerViewStatus = smallPlayerViewStatus
            self.isPlaying = isPlaying
            self.isShowingSmallPlayer = isShowingSmallPlayer
        }
    }
    
    // MARK: - Action
    enum Action {
        case appeared
        case nextButtonTap
        case previousButtonTap
        case playButtonTap
        case updateSlider
        case _playerResponse(AVPlayer.Status)
        case _itemResponse(AVPlayerItem.Status)
    }
    
    // MARK: - reduce
    func reduce(
        _ state: inout State,
        action: Action
    ) -> AnyPublisher<Action, Never> { 
        
        switch action {
            
        case .appeared:
            guard state.isPlaying == true else { break }
            state.smallPlayerViewStatus = .loading
            return AudioManager.shared.status()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case ._playerResponse(.readyToPlay):
            state.smallPlayerViewStatus = .none
            state.isPlaying = true
            state.isShowingSmallPlayer = true
            guard let currentEpisode = PlayListManager.shared.currentEpisode else { break }
            state.title = currentEpisode.title
            state.imageUrl = currentEpisode.image
            
        case ._playerResponse(.failed):
            state.isPlaying = false
            state.isShowingSmallPlayer = false
            state.smallPlayerViewStatus = .none
            
        case .nextButtonTap:
            guard let episode = PlayListManager.shared.getNextAudio() else { break }
            state.smallPlayerViewStatus = .loading
            AudioManager.shared.pause()
            AudioManager.shared.url = state.createUrl(from: episode)
            
            return AudioManager.shared.playMedia()
                .map(Action._itemResponse)
                .eraseToAnyPublisher()
            
        case .previousButtonTap:
            guard let episode = PlayListManager.shared.getPreviousAudio() else { break }
            state.smallPlayerViewStatus = .loading
            AudioManager.shared.pause()
            AudioManager.shared.url = state.createUrl(from: episode)
            
            return AudioManager.shared.playMedia()
                .map(Action._itemResponse)
                .eraseToAnyPublisher()
            
        case ._itemResponse(.readyToPlay):
            state.isPlaying = true
            state.smallPlayerViewStatus = .none
            state.isShowingSmallPlayer = true
            
            guard let currentEpisode = PlayListManager.shared.currentEpisode else { break }
            state.title = currentEpisode.title
            state.imageUrl = currentEpisode.image
            
            AudioManager.shared.play()
            
        case ._itemResponse(.failed):
            state.isPlaying = false
            state.smallPlayerViewStatus = .none
            break
            
        case._itemResponse(_): // .unknown
            break
            
        case .playButtonTap:
            switch state.isPlaying {
            case true:
                AudioManager.shared.pause()
            case false:
                AudioManager.shared.play()
            }
            state.isPlaying.toggle()
            
        case .updateSlider:
            break
            
        case ._playerResponse(_): // .unknown
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - SmallPlayerStore
class SmallPlayerStore: ObservableObject {
    @Published private(set) var state: SmallPlayerDomain.State
    private var reducer: SmallPlayerDomain
    
    private var cancelable: Set<AnyCancellable> = .init()
    
    init(
        state: SmallPlayerDomain.State,
        reducer: SmallPlayerDomain
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: SmallPlayerDomain.Action) {
        reducer.reduce(&state, action: action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelable)
    }
}
