//
//  PlayerView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI
import LoadableImage

struct PlayerView: View {
    var albumImage: String
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center) {
                       AlbumImage(geometry: geometry)
                    }
                    
                    TextTitle(episodeTitle: "Title", authorTitle: "Author")
                    
                    SliderStack(startTime: "0:00", timeLeft: "25:45", value: 2, duration: 3)
                    
                    HStack(alignment: .center, spacing: 32) {
                        ShuffleButton()
                        BackTrackButton()
                        PlayButton()
                        NextTrackButton()
                        RepeatButton()
                    }
                    .padding(.horizontal, 48)
                    .padding(.top, 50)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Now Playing")
    }
}

#Preview {
    PlayerView(albumImage: "r3")
}
