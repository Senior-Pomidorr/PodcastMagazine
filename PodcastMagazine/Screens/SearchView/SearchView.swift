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
    var trendItems: [Feed]
    var categories: [Models.Category]
    
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
                    
                    
                    SearchHGridView(items: trendItems)
                }
                .padding(.bottom, 24)
                
                SearchVGridView(items: categories)
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
    static var category = Models.Category.sample
    
    static var previews: some View {
        SearchView(
            text: .constant("Ppdlodca"),
            trendItems: [item],
            categories: [category]
        )
    }
}
