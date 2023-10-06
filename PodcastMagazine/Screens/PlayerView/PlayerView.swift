//
//  PlayerView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI
import LoadableImage
import Models

struct PlayerView: View {
    @StateObject private var store: PlayerStore
    @State private var isEditing = false
    @State private var isPlayning = false
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            
            switch store.state.playerStatus {
            case .none:
                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center) {
                           AlbumImage(geometry: geometry)
                        }
                        
                        TextTitle(
                            episodeTitle: store.state.title,
                            authorTitle: "Author"
                        )
                        
                        SliderStack(
                            sliderValue: bindingSlider(),
                            isEditing: $isEditing,
                            duration: store.state.duration,
                            startTime: "",
                            timeLeft: ""
                        )
                        
                        HStack(alignment: .center, spacing: 32) {
                            ShuffleButton()
                            
                            Button {
                                //
                            } label: {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                            
                            Button {
                                isPlayning ? store.send(.pause) : store.send(.play)
                                isPlayning.toggle()
                                
                            } label: {
                                Image("PlayButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                            }
                            
                            Button {
                                //
                            } label: {
                                Image("nextTrack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                            
                            RepeatButton()
                        }
                        .padding(.horizontal, 48)
                        .padding(.top, 50)
                    }
                    .padding(.top, 20)
                }
            case .loading:
                ProgressView()
            case .error(let error):
                Text("Экран ошибки, ошибка: \(error.localizedDescription)")
            }
        }
        .onAppear {
            store.send(.onAppeared)
        }
        .onReceive(timer) { _ in
            if isEditing {
                store.send(.updateSliderValue)
            }
        }
    }
    
    // MARK: - binding
    func bindingSlider() -> Binding<TimeInterval> {
        .init {
            store.state.sliderValue
        } set: {
            store.send(.seek($0))
        }
    }
    
    // MARK: - init(:)
    init(
        selectedEpisode: Episode,
        episodes: [Episode]
    ) {
        let store = PlayerStore(
            state: PlayerDomain.State(
                episodes: episodes,
                selectedEpisod: selectedEpisode),
            reducer: PlayerDomain(audioManager: AudioManager())
        )
        
        _store = .init(wrappedValue: store)
    }
}

#Preview {
    PlayerView(
        selectedEpisode: Episode.sample,
        episodes: [Episode.sample]
    )
}
