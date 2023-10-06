//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import SwiftUI
import Models

struct SearchContentView: View {
    @StateObject private var store = SearchDomain.searchStoreLive

    var body: some View {
        NavigationView {
            switch store.state.searchScreenStatus {
            case .none:
                SearchView(
                    trendItems: store.state.trendPodcasts,
                    categories: store.state.categories
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
}


struct SearchContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentView()
    }
}
