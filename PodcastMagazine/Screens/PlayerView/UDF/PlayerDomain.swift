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

        var episodes: [Episode]
        var selectedEpisode: Episode
        var screenStatus: ScreenStatus
        
        var currentIndex: Int = .init()
        
        var duration: TimeInterval
        var timeLeft: TimeInterval
        var currentTime: TimeInterval

        var title: String
        var image: String
        
        var isPlaying: Bool
        var isShuffled: Bool = false
        
        // MARK: - init(:)
        init(
            episodes: [Episode] = .init(),
            selectedEpisode: Episode = Episode.sample,
            playerStatus: ScreenStatus = .none,
            duration: TimeInterval = .init(),
            timeLeft: TimeInterval = .init(),
            currentTime: TimeInterval = .init(),
            title: String = .init(),
            image: String = .init(),
            isPlaying: Bool = false
        ) {
            self.episodes = episodes
            self.selectedEpisode = selectedEpisode
            self.screenStatus = playerStatus
            self.duration = duration
            self.timeLeft = timeLeft
            self.currentTime = currentTime
            self.title = title
            self.image = image
            self.isPlaying = isPlaying
        }
        
        // MARK: - Methods
        func findEpisodeBy(id: Int) -> Episode {
            return episodes.first { $0.id == id}!
        }
        
        func findIndexBy(_ episode: Episode) -> Int? {
            return episodes.firstIndex(of: episode)
        }
        
        func findNextEpisode() -> Episode? {
            guard currentIndex < episodes.count - 1 else { return nil }
            let index = currentIndex + 1
            return episodes[index]
        }
        
        func findPreviousEpisode() -> Episode? {
            guard (currentIndex - 1) >= 0 else { return nil }
            let index = currentIndex - 1
            return episodes[index]
        }
        
        func createUrl(from episode: Episode?) -> URL? {
            guard let url = episode.map(\.enclosureUrl) else { return nil }
            return URL(string: url)
        }
    }
    
    // MARK: - Action
    enum Action {
        case onAppeared
        case playButtonTap
        case updateSliderValue
        case nextButtonTap
        case previousButtonTap
        case shuffleButtonTap
        case _playerResponse(AVPlayerItem.Status)
        case seek(TimeInterval) // Поиск по временной шкале трека
    }
    
    // MARK: - Dependencies
//    let audioManager: AudioManager
    
    // MARK: - func reduce
    func reduce(
        _ state: inout State,
        action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
            
        case .onAppeared:
            guard state.screenStatus != .loading else {
                break
            }
            // first start
            state.screenStatus = .loading
            AudioManager.shared.url = state.createUrl(from: state.selectedEpisode)
            state.currentIndex = state.findIndexBy(state.selectedEpisode) ?? 0
            
            return AudioManager.shared.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case ._playerResponse(.readyToPlay):
            state.screenStatus = .none
            state.currentTime = 0.0
            state.duration = AudioManager.shared.duration
            state.title = state.selectedEpisode.title
            state.image = state.selectedEpisode.image
            // play
            AudioManager.shared.play()
            
        case ._playerResponse(.failed):
            let error = PlayerError.failLoading
            state.screenStatus = .error(error)
            
        case .playButtonTap:
            switch state.isPlaying {
            case true: 
                AudioManager.shared.play()
            case false:
                AudioManager.shared.pause()
            }
            state.isPlaying.toggle()
            
        case .nextButtonTap:
            guard let episode = state.findNextEpisode() else { break }
            AudioManager.shared.pause()
            state.screenStatus = .loading
            state.currentIndex = state.findIndexBy(episode) ?? 0
            state.selectedEpisode = episode
            AudioManager.shared.url = state.createUrl(from: episode)
            
            return AudioManager.shared.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case .previousButtonTap:
            guard let episode = state.findPreviousEpisode() else { break }
            AudioManager.shared.pause()
            state.screenStatus = .loading
            state.currentIndex = state.findIndexBy(episode) ?? 0
            state.selectedEpisode = episode
            AudioManager.shared.url = state.createUrl(from: episode)
            
            return AudioManager.shared.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case .updateSliderValue:
            state.currentTime = checkingForNaN(AudioManager.shared.currentTime)
            state.timeLeft = checkingForNaN(AudioManager.shared.timeLeft)
  
        case let .seek(timeInterval):
            state.currentTime = timeInterval
            return Future<Action, Never> { promise in
                Task {
                    await AudioManager.shared.seek(to: timeInterval)
                    promise(.success(.updateSliderValue))
                }
            }
            .eraseToAnyPublisher()
            
        case .shuffleButtonTap:
            switch state.isShuffled {
            case true:
                state.episodes = state.episodes.shuffled()
            case false:
                state.episodes = state.episodes.sorted(by: {
                    $0.title.lowercased() < $1.title.lowercased()
                })
            }
            state.isShuffled.toggle()
            
        case ._playerResponse(_):
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    func checkingForNaN(_ time: TimeInterval) -> Double {
        guard time.isNaN != true else { return 0.0 }
        return time
    }
}

// MARK: - PlayerStore
class PlayerStore: ObservableObject {
    @Published private(set) var state: PlayerDomain.State
    
    private var reducer: PlayerDomain
    private var cancelable: Set<AnyCancellable> = .init()
    
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
            .store(in: &cancelable)
    }
}
