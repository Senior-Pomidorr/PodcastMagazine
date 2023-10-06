//
//  PlayerDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Combine
import Models
import Foundation

enum PlayerError: Error {
    case failLoading
}

struct PlayerDomain {
    // MARK: - State
    struct State {
        var episodes:[Episode]
        var playerStatus: ScreenStatus
        
        var duration: TimeInterval
        var currentTime: TimeInterval
        var timeLeft: TimeInterval
        var sliderValue: TimeInterval
        
        init(
            episodes: [Episode] = .init(),
            playerStatus: ScreenStatus = .none,
            duration: TimeInterval = .init(),
            currentTime: TimeInterval = .init(),
            timeLeft: TimeInterval = .init(),
            sliderValue: TimeInterval = .init()
        ) {
            self.episodes = episodes
            self.playerStatus = playerStatus
            self.duration = duration
            self.currentTime = currentTime
            self.timeLeft = timeLeft
            self.sliderValue = sliderValue
        }
    }
    
    // MARK: - Action
    enum Action {
        case onAppeared
        case play
        case pause
        case setSliderValue(TimeInterval)
        case updateSliderValue
//        case nextAudio
//        case backAudio
        case _playerResponse(AVPlayerItem.Status)
        case seek(TimeInterval) // поиск места на треке (прогресс или перемотка)
    }
    
    // MARK: - Dependencies
    let audioManager: SoundManager
    
    // MARK: - func reduce
    func reduce(
        _ state: inout State,
        action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .onAppeared:
            
            guard state.playerStatus != .loading else {
                break
            }
            state.playerStatus = .loading
            audioManager.urlString = state.episodes.first!.enclosureUrl
            
            return audioManager.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case ._playerResponse(.readyToPlay):
            state.playerStatus = .none
            state.duration = audioManager.duration
            
        case ._playerResponse(.failed):
            let error = PlayerError.failLoading
            state.playerStatus = .error(error)
  
        case .play:
            audioManager.play()
        case .pause:
            audioManager.pause()
            
        case .updateSliderValue:
            state.sliderValue = audioManager.currentTime
            
        case .setSliderValue:
            break
            
        case let .seek(timeInterval):
            state.sliderValue = timeInterval
            Task {
                await audioManager.seek(to: timeInterval)
            }
            
        case ._playerResponse(_):
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}


class PlayerStore: ObservableObject {
    @Published private(set) var state: PlayerDomain.State
    
    private var reducer: PlayerDomain
    private var cancelleble: Set<AnyCancellable> = .init()
    
    init(
        state: PlayerDomain.State,
        reducer: PlayerDomain
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: PlayerDomain.Action) {
        reducer.reduce(&state, action: action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelleble)
    }
}
