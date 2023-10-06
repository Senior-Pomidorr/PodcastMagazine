//
//  EpisodeCellView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 1.10.23.
//

import SwiftUI
import Models
import LoadableImage

struct EpisodeCellView: View {
    
    var episode: Episode
    
    @State private var navigateToEpisodePlayer = false
    
    var body: some View {
        HStack(spacing: 8) {
            LoadableImage(episode.image) { image in
                image
                    .resizable()
            }
            .frame(width: 56, height: 56)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 8)
            
            HStack(alignment: .top) {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text(episode.title)
                    }
                    .padding(.bottom, 6)
                    
                    HStack(alignment: .top) {
                        Text(episode.description)
                    }
                    .font(.custom(.light, size: 12))
                    .foregroundStyle(Color.gray)
                }
                Spacer()
            }
        }
        .frame(height: 72)
        .background(Color.color5.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 5)
        .onTapGesture {
            print("press episode cell")
            print("EPISODE ID =", episode.id)
            navigateToEpisodePlayer = true
        }
        .background(
            NavigationLink(
                destination:
                   EmptyView(),
                isActive: $navigateToEpisodePlayer,
                label: {
                    EmptyView()
                }
            )
        )
    }
}

#Preview {
    EpisodeCellView(episode: Episode.sample)
}
