//
//  SmallAudioPlayerView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 08.10.23.
//

import SwiftUI
import LoadableImage

struct SmallAudioPlayerView: View {
    var title: String
    var urlImage: String
    var playButtonAction: () -> Void
    var nextButtonAction: () -> Void
    var previousButtonAction: () -> Void
    var isPlaying: Bool = false
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 43, height: 43)
                .overlay {
                    LoadableImage(urlImage) { image in
                         image
                            .resizable()
                    }
                }
            
            Text(title)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            
            HStack {
                
                Button {
                    previousButtonAction()
                } label: {
                    Image(systemName: "backward.end")
                }
                Button {
                    playButtonAction()
                } label: {
                    Image(systemName: 
                            isPlaying ? "pause.circle" : "play.circle")
                        .font(.title)
                }
                Button {
                    nextButtonAction()
                } label: {
                    Image(systemName: "forward.end")
                }
            }
            .foregroundStyle(.black)
        }
        .frame(height: 25)
        .padding()
        .padding(8)
        .background(Color.color3.edgesIgnoringSafeArea(.bottom))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}
//
//#Preview {
//    SmallAudioPlayerView()
//}
//
