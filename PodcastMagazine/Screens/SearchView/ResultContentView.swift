//
//  ResultContentView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//

import SwiftUI
import Models

struct ResultContentView: View {
    @StateObject private var store: ResultStore

    var rows: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            switch store.state.searchScreenStatus {
            case .none:
                ResultView(
                    query: store.state.userQuery,
                    items: store.state.genres,
                    podcastItems: store.state.podcasts
                )
            case .loading:
                ProgressView()
            case .error(let error):
                Text("Произошла ошибка: \(error.localizedDescription)")
            }
        }
        .onAppear {
            store.send(.viewAppeared)
        }
    }
    
    init(userQuery: String) {
        let store = ResultStore(
            state: ResultDomain.State(query: userQuery),
            reduser: ResultDomain(provider: .live).reduce(_:with:)
        )
        _store = .init(wrappedValue: store)
    }
}

#Preview {
    ResultContentView(userQuery: "Query text")
}

struct ResultView: View {
    var query: String
    let items: [Feed]
    let podcastItems: [Feed]
    
    init(
        query: String,
        items: [Feed],
        podcastItems: [Feed]
    ) {
        self.query = query
        self.items = items
        self.podcastItems = podcastItems
    }
    
    private var rows: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        
        VStack {
            HeaderResultView(title: query)
                .padding(.bottom, 24)
            
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: rows,
                              alignment: .center,
                              spacing: nil,
                              pinnedViews: [],
                              content: {
                        Section {
                            ForEach(items, id: \.id) { item in
                                ContentCellView(item: item)
                                    .frame(height: 72)
                            }
                        } header: {
                            HStack {
                                Text("Search Result")
                                    .foregroundStyle(Color.searchBarText)
                                    .font(.custom(.extraBold, size: 14))
                                Spacer()
                            }
                        }
                        
                        Section {
                            ForEach(podcastItems, id: \.id) { item in
                                ContentCellView(item: item)
                                    .frame(height: 72)
                            }
                        } header: {
                            HStack {
                                Text("All Podcast")
                                    .foregroundStyle(Color.secondaryText)
                                    .font(.custom(.medium, size: 14))
                                Spacer()
                            }
                        }
                    })
                }
                .padding(.horizontal, 33)
            }
                
        }
        .navigationBarHidden(true)
        .padding(.top, 49)
    }
}
