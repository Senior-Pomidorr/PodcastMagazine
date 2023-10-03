//
//  PodcastCellView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 28.09.23.
//

import SwiftUI
import Models
import LoadableImage

struct PodcastCellView: View {
    @ObservedObject var store: HomePageStore
    var podcast: Feed
    @State private var navigateToPodcastDescription = false
    
    var body: some View {
        HStack(spacing: 8) {
            
            LoadableImage(podcast.image ?? "") { image in
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
                        if podcast.episodeCount ?? 0 > 0 {
                            Text("•")
                            Text("\(podcast.episodeCount ?? 0)" + " Eps")
                        }
                    }
                    .font(.custom(.light, size: 12))
                    .foregroundStyle(Color.gray)
                }
            }
            
            Spacer()
            
            VStack {
                Button {
                    print("add/del from favorite")
                    if inFavorite(feed: podcast) {
                        store.send(.removeFeedFromFavorites(podcast))
                    } else {
                        store.send(.addFeedToFavorites(podcast))
                    }
                    store.send(.getPersistedFeeds)
                } label: {
                    Image(systemName: inFavorite(feed: podcast) ? "heart.fill" : "heart")
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
            print("PODCAST ID =", podcast.id)
            navigateToPodcastDescription = true
        }
        .background(
            NavigationLink(
                destination: PodcastDiscriptionView(podcastID: podcast.id, store: store),
                isActive: $navigateToPodcastDescription,
                label: {
                    EmptyView()
                }
            )
        )
    }
    
    private func inFavorite(feed: Feed) -> Bool {
        return store.state.persistedFeeds?.contains { $0.id == feed.id } ?? false
    }
}

//#Preview {
//    PodcastCellView()
//}
