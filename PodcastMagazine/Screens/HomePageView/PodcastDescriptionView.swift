//
//  PodcastDescriptionView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 1.10.23.
//

import SwiftUI
import Models
import LoadableImage

struct PodcastDiscriptionView: View {
    
    var podcastID: Int
    @StateObject var store: PodcastDescriptionStore = PodcastDescriptionDomain.liveStore
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    
                    switch store.state.pageLoadingStatus {
                    case .none:
                        VStack(alignment: .center, spacing: 8) {
                            RoundedRectangle(cornerRadius: 21)
                                .fill(Color.color3)
                                .frame(width: 84, height: 84)
                                .overlay {
                                    LoadableImage(store.state.feedDetail.feed.image ?? "") { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    }
                                }
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            Text(store.state.feedDetail.feed.title)
                                .font(.custom(.bold, size: 16))
                                .foregroundStyle(Color.black)
                            
                            HStack(alignment: .top) {
                                
                                if store.state.feedDetail.feed.episodeCount ?? 0 > 0 {
                                    Text("\(store.state.feedDetail.feed.episodeCount ?? 0)" + " Eps")
                                } else {
                                    Text("No eps. count")
                                }
                                Text("⎮")
                                Text(store.state.feedDetail.feed.author ?? "No author")
                            }
                            .font(.custom(.light, size: 14))
                            .foregroundStyle(Color.gray)
                            
                            HStack {
                                Text("All Episode")
                                    .font(.custom(.bold, size: 16))
                                    .foregroundStyle(Color.black)
                                Spacer()
                            }
                            .padding(.top)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(store.state.episodeList) { episode in
                                        EpisodeCellView(episode: episode)
                                            .padding(.horizontal, 8)
                                    }
                                }
                            }
                            
                        }
                    case .loading:
                        ProgressView()
                    case let .error(error):
                        VStack {
                            Text(error.localizedDescription)
                            Image(systemName: "wifi.slash")
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                    }

                    Spacer()
                }
            }
            .padding()
        }
        .onAppear {
            print("Пришел id =", podcastID)
            store.send(.viewAppeared(podcastID))
        }
        .background(Color.white)
        .navigationTitle("Podcast")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    PodcastDiscriptionView(podcastID: 75075, store: PodcastDescriptionDomain.liveStore)
}