//
//  PlayerView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI

struct PlayerView: View {
    var albumImage: String
    var episodeTitle: String
    var authorTitle: String
    var startTimePocast: String
    var endTimePocast: String
    @State var sliderTimeTrack: Double
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(albumImage)
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.50)
                            .background(Color("tintBlue2"))
                            .cornerRadius(16)
                            .shadow(radius: 8)
                        Spacer()
                    }
                    VStack(spacing: 0) {
                        Text(episodeTitle)
                            .font(.custom(.bold, size: 16))
                            .kerning(0.32)
                        Text(authorTitle)
                            .font(.custom(.regular, size: 14))
                            .foregroundStyle(Color("GreyTextColor"))
                            .padding(.top, 5)
                    }
                    .padding(.top, 36)
                    
                    HStack {
                        Text(startTimePocast)
                            .foregroundStyle(Color("mainText"))
                            .font(.custom(.regular, size: 14))
                        Slider(value: $sliderTimeTrack, in: 0...5)
                            .padding()
                        Text(endTimePocast)
                            .foregroundStyle(Color("mainText"))
                            .font(.custom(.regular, size: 14))
                    }
                    .padding(.horizontal, 48)
                    .padding(.top, 38)
                    
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
    PlayerView(albumImage: "r3", episodeTitle: "Title", authorTitle: "Author", startTimePocast: "00:00", endTimePocast: "23:45", sliderTimeTrack: 2)
}
