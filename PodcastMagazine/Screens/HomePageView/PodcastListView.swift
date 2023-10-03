//
//  PodcastListView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 2.10.23.
//

import SwiftUI
import Models
import LoadableImage

struct PodcastListView: View {
    
    var category: Models.Category
    @ObservedObject var store: HomePageStore
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    
                    switch store.state.podcastsListLoadingStatus {
                    case .none:
                        VStack(alignment: .center, spacing: 8) {
                            ZStack(alignment: .bottom) {
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(category.id % 2 == 0 ? Color.color3 : Color.color1)
                                    .frame(width: 144, height: 200)
                                    .overlay {
                                        LoadableImage("https://random.imagecdn.app/150/200") { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(category.id % 2 == 0 ? Color.color4 : Color.color2)
                                    .frame(width: 144, height: 64)
                                    .overlay(
                                        Text("\(category.name)")
                                            .font(.custom(.bold, size: 14))
                                            .foregroundStyle(.black)
                                            .frame(width: 144, height: 64, alignment: .center)
                                            .minimumScaleFactor(0.5)
                                    )
                            }
                            
                            HStack {
                                Text("All Podcasts")
                                    .font(.custom(.bold, size: 16))
                                    .foregroundStyle(Color.black)
                                Spacer()
                            }
                            .padding(.top)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 16) {
                                    ForEach(store.state.podcastsListByCategory) { podcast in
                                        PodcastCellView(store: store, podcast: podcast)
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
            store.send(.getPodcastListByCategory(category))
        }
        .background(Color.white)
        .navigationTitle("Podcasts List")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
    
    
}

#Preview {
    PodcastListView(category: Category.sample, store: HomePageDomain.liveStore)
}
