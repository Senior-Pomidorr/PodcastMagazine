//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//
import Models
import SwiftUI

struct SearchView: View {
    @Binding var text: String
    var topTtems: [Feed]?
    var allTtems: [Feed]?
    
    @State private var showingDetailView = false

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
                            .frame(height: 48.0)
                            .onSubmit {
                                showingDetailView = true
                            }
                    }
                    .padding(.horizontal, 32)
                    
                    
                    SearchHGridView()
                }
                .padding(.bottom, 24)
                
                SearchVGridView()
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingDetailView) {
            Text("Destination DetailView. User text is \(text)")
        }
    }
}

// MARK: - SearchView_Previews
struct SearchView_Previews: PreviewProvider {
    static var item = Feed.sample
    
    static var previews: some View {
        SearchView(
            text: .constant("Ppdlodca"),
            topTtems: [item],
            allTtems: [item]
        )
    }
}


// MARK: - SearchHGridView
struct SearchHGridView: View {
    let mocItems: [Feed] = Array(repeating: Feed.sample, count: 20)
    var topItems: [Feed]?
    
    var rows = [
        GridItem(.flexible(minimum: 84, maximum: 84))
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
                    ForEach(mocItems.indices, id: \.self) { index in
                        NavigationLink(
                            destination: Text("Destination. id: \(index), Category - top"),
                            label: {
                                PodcastElement(item: nil)
                                    .frame(width: calculateItemWidth())
                            })
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
    let mocItems: [Feed] = Array(repeating: Feed.sample, count: 20)
    var allItems: [Feed]?
    
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
                        ForEach(mocItems.indices, id: \.self) { index in
                            NavigationLink(
                                destination: Text("Destination. id: \(index), Category - all"),
                                label: {
                                    PodcastElement(item: nil)
                                        .frame(height: 84)
                                })
                        }
                    }
            }
            .padding(.horizontal, 33)
        }
    }
}
