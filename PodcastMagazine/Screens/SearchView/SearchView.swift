//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var store = SearchStore(
        state: SearchScreenDomain.State(),
        reduser: SearchScreenDomain.live.reduce(_:with:)
    )
    
    var body: some View {
        NavigationView {
            switch store.state.searchScreenStatus {
            case .none:
                SearchScreenView()
            case .loading:
                ProgressView()
            case .error(let error):
                Text("Произошла ошибка: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SearchView()
}

struct SearchScreenView: View {
    var body: some View {
        ZStack {
            // Временный фоновый цвет
            Color.gray.opacity(0.2)
                .ignoresSafeArea(edges: .all)
            VStack {
                Text("Search")
                SearchBarView(searchText: .constant(""))
            }
        }
    }
}
