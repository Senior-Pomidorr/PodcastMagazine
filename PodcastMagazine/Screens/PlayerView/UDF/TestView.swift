//
//  TestView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import Models
import SwiftUI

struct TestView: View {
    @StateObject var store: PlayerStore
    @State private var isEditing = false
    
        let timer = Timer
            .publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
    
    var body: some View {
        VStack {
            switch store.state.playerStatus {
            case .none:
                VStack {
                    Button("Play") {
                        store.send(.play)
                    }
                    
                    Button("Pause") {
                        store.send(.pause)
                    }
                    
                    PlayerSliderView(
                        sliderValue: bindingSlider(),
                        duration: store.state.duration,
                        isEditing: $isEditing
                    )
                }
            case .loading:
                ProgressView()
            case .error(let error):
                Text("Error message: \(error.localizedDescription)")
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
    
    func bindingSlider() -> Binding<TimeInterval> {
        .init {
            store.state.sliderValue
        } set: {
            store.send(.seek($0))
        }
    }
    
    // MARK: - init(:)
    init(episodeURL: String) {
        let store = PlayerStore(
            state: PlayerDomain.State(
                episodes: [Episode.sample]
            ),
            reducer: PlayerDomain(audioManager: AudioManager())
        )
        _store = .init(wrappedValue: store)
    }
}

struct PlayerSliderView: View {
    var sliderValue: Binding<TimeInterval>
    var duration: TimeInterval
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            Slider(
                value: sliderValue,
                in: 0...duration
            ) { editing in isEditing = editing }
        }
        .padding()
    }
}

//#Preview {
//    TestView()
//}
