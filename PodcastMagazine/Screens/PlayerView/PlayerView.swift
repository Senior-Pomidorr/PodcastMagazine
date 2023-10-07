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
    
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            
            switch store.state.screenStatus {
            case .none:
                PlayerContentView(
                    image: store.state.image,
                    title: store.state.title,
                    playButtonAction: { store.send(.playButtonTap) },
                    nextButtonAction: { store.send(.nextButtonTap) },
                    previousButtonAction: { store.send(.previousButtonTap) }, 
                    shuffleButtonAction: { store.send(.shuffleButtonTap) },
                    isPlaying: store.state.isPlaying,
                    sliderValue: bindingSlider(),
                    duration: store.state.duration,
                    timeLeft: store.state.timeLeft
                )
                
            case .loading:
                LoadingPlayerView()
                
            case .error(let error):
                ErrorPlayerView(error: error)
            }
        }
        .onAppear {
            store.send(.onAppeared)
        }
        .onReceive(timer) { _ in
            store.send(.updateSliderValue)
        }
    }
    
    // MARK: - binding
    func bindingSlider() -> Binding<TimeInterval> {
        .init {
            store.state.currentTime
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
                selectedEpisode: selectedEpisode),
            reducer: PlayerDomain()
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

// MARK: - PlayerContentView
struct PlayerContentView: View {
    var image: String
    var title: String
    var playButtonAction: () -> Void
    var nextButtonAction: () -> Void
    var previousButtonAction: () -> Void
    var shuffleButtonAction: () -> Void
    
    var isPlaying: Bool
    
    var sliderValue: Binding<TimeInterval>
    var duration: TimeInterval
    
    var timeLeft: TimeInterval
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Spacer()
                    LoadableImage(image) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }
                        .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.50)
                        .background(Color("tintBlue2"))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    Text(title)
                        .font(.custom(.bold, size: 16))
                        .kerning(0.32)
                        .lineLimit(2)
                }
                .padding(.top, 36)
                
                SliderStack(
                    value: sliderValue,
                    duration: duration,
                    timeLeft: timeLeft
                )
                
                HStack(alignment: .center, spacing: 32) {
                    Button {
                        print("shuffle tap")
                    } label: {
                        Image("shuffle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                    Button {
                        previousButtonAction()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                    Button {
                        playButtonAction()
                    } label: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 64, height: 64)
                            .overlay {
                                Image(systemName: isPlaying ? "play.fill" : "pause.fill")
                                    
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    
                    Button {
                        nextButtonAction()
                    } label: {
                        Image("nextTrack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                    Button {
                        shuffleButtonAction()
                    } label: {
                        Image("repeat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.horizontal, 48)
                .padding(.top, 50)
            }
            .padding(.top, 20)
        }
        .navigationTitle("Now playing")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

// MARK: - LoadingPlayerView
struct LoadingPlayerView: View {
    var body: some View {
        VStack {
            ProgressView()
        }
        .navigationTitle("Now playing")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

// MARK: - ErrorPlayerView
struct ErrorPlayerView: View {
    var error: Error
    
    var body: some View {
        VStack {
            Text("\(error.localizedDescription)")
        }
        .navigationTitle("Error")
    }
}
