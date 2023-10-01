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
    ResultContentView(userQuery: "Podlodka")
}
