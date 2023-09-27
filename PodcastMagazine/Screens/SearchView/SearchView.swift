//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import SwiftUI
import Models

struct SearchView: View {
    @StateObject private var store = SearchStore(
        state: SearchDomain.State(),
        reduser: SearchDomain.live.reduce(_:with:)
    )
    
    var body: some View {
        NavigationView {
            switch store.state.searchScreenStatus {
            case .none:
                SearchScreenView(text: searchText())
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

// MARK: - Previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

//#Preview {
//    SearchView()
//}

struct SearchScreenView: View {
    @Binding var text: String
    
//    var rows = [
//        GridItem(.flexible(minimum: 60, maximum: 84))
//    ]
    
//    var colum: [GridItem] = [
//        GridItem(.flexible(), spacing: 17),
//        GridItem(.flexible())
//    ]
    
    var body: some View {
        ZStack {
            // Временный фоновый цвет
            Color.gray.opacity(0.2)
                .ignoresSafeArea(edges: .all)
            
            
            VStack(spacing: 0) {
                VStack(spacing: 35) {
                    VStack(spacing: 33) {
                        Text("Search")
                            .frame(maxWidth: .infinity)
                        SearchBarView(searchText: $text)
                    }
                    .padding(.horizontal, 32)
                    
                    
                    SearchHGridView()
                }
                .padding(.bottom, 24)
                
                SearchVGridView()
            }
        }
    }
}


// MARK: - SearchHGridView
struct SearchHGridView: View {
    var rows = [
        GridItem(.flexible(minimum: 60, maximum: 84))
    ]
    
    var body: some View {
        VStack(spacing: 13) {
            HStack {
                Text("Top Genres")
                Spacer()
                Text("See all")
            }
            .padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows,
                          alignment: .center,
                          spacing: 17,
                          pinnedViews: [],
                          content: {
                    ForEach(0..<30) { index in
                        Rectangle()
                            .fill(.gray)
                            .frame(width: calculateItemWidth())
                    }
                })
                .padding(.horizontal, 33)
            }
        }
    }
    
    private func calculateItemWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 17
        let padding: CGFloat = 33
        let totalSpacing = spacing + padding * 2
        let itemWidth = (screenWidth - totalSpacing) / 2
        return itemWidth
    }
}


// MARK: - SearchVGridView
struct SearchVGridView: View {
    var colum: [GridItem] = [
        GridItem(.flexible(), spacing: 17),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 21) {
            HStack {
                Text("Browse all")
                Spacer()
            }
            .padding(.horizontal, 32)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: colum,
                    alignment: .center,
                    spacing: 17,
                    pinnedViews: []) {
                        ForEach(0..<30) { index in
                            Rectangle()
                                .frame(height: 84)
                        }
                    }
            }
            .padding(.horizontal, 33)
        }
    }
}


struct GenreItemView: View {
    let mocData = Feed.sample
    
    var body: some View {
        HStack {
            Text(mocData.title)
        }
        .frame(width: 147, height: 84)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
        }
    }
}
