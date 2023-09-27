//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import SwiftUI
import Models

struct SearchContentView: View {
    @StateObject private var store = SearchStore(
        state: SearchDomain.State(),
        reduser: SearchDomain.live.reduce(_:with:)
    )
    
    let items: [Feed] = [Feed.sample]
    
    var body: some View {
        NavigationView {
            switch store.state.searchScreenStatus {
            case .none:
                SearchView(text: searchText())
            case .loading:
                ProgressView()
            case .error(let error):
                Text("Произошла ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func searchText() -> Binding<String> {
        .init {
            store.state.textQuery
        } set: {
            store.send(.didTypeQuery($0))
        }
        
    }
}


struct SearchContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentView()
    }
}
