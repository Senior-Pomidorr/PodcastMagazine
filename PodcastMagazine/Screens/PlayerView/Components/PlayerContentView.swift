//
//  PlayerContentView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 07.10.23.
//

import SwiftUI
import LoadableImage

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
    var isShuffled: Bool
    
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
                
                VStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .font(.custom(.bold, size: 16))
                        .kerning(0.32)
                        .lineLimit(2)
                }
                .padding(.top, 36)
                .padding(.horizontal, 33)
                
                SliderStack(
                    value: sliderValue,
                    duration: duration,
                    timeLeft: timeLeft
                )
                
                HStack(alignment: .center, spacing: 32) {
                    Button {
                        shuffleButtonAction()
                    } label: {
                        Image(systemName: "shuffle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(
                                isShuffled ? .blue : .gray
                            )
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
                        //
                    } label: {
                        Image(systemName: "repeat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.gray)
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

//#Preview {
//    PlayerContentView()
//}
