//
//  PodcastCellView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 28.09.23.
//

import SwiftUI
import Models

struct PodcastCellView: View {
    
    var podcast: Feed = Feed.sample
    var podcastInFavorite: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            
            AsyncImage(
                url: URL(string: podcast.image ?? "")
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 56, height: 56)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 8)

            HStack(alignment: .top) {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text(podcast.title)
                            .lineLimit(1)
                            .font(.custom(.semiBold, size: 14))
                            .foregroundStyle(Color.black)
                        Text("|")
                            .foregroundStyle(Color.gray)
                        Text(podcast.author ?? "No author")
                            .lineLimit(1)
                            .font(.custom(.light, size: 12))
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.bottom, 6)
                    
                    HStack(alignment: .top) {
                        Text(podcast.categories?.first?.value ?? "No category")
                        Text("•")
                        Text("\(podcast.episodeCount ?? 10)" + "+ Eps")
                    }
                    .font(.custom(.light, size: 12))
                    .foregroundStyle(Color.gray)
                }
            }
            
            Spacer()
            
            VStack {
                Button {
                    print("add/del from favorite")
                } label: {
                    Image(systemName: podcastInFavorite ? "heart.fill" : "heart")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.red)
                }
                .background(.ultraThinMaterial)
                .background(.white)
                .clipShape(Circle())
            }
            .padding(.trailing, 16)
        }
        .frame(height: 72)
        .background(Color.color5.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 5)
        .onTapGesture {
            print("press podcast cell")
        }
    }
}

#Preview {
    PodcastCellView(podcast: Feed.sample)
}
