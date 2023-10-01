//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//
import Models
import SwiftUI

struct SearchView: View {
    var trendItems: [Feed]
    var categories: [Models.Category]
    
    @State private var queryText: String = ""
    @State private var showingDetailView = false

    var body: some View {
        ZStack {
            BackgroundGradient()
  
            VStack(spacing: 33) {
                VStack(spacing: 33) {
                    TextView(
                        text: "Search",
                        size: 16,
                        style: .extraBold
                    )
                    .frame(maxWidth: .infinity)
                    
                    SearchBarView(queryText: $queryText)
                        .frame(height: 48.0)
                        .onSubmit {
                            showingDetailView = true
                        }
                }
                .padding(.horizontal, 33)
                
                VStack(spacing: 24) {
                    SearchHGridView(items: trendItems)
                    
                    SearchVGridView(items: categories)
                }
            }
            .padding(.top, 58)
            
            // навигационный костыль, потому что инструменты из 16.0 недоступны
            NavigationLink(isActive: $showingDetailView) {
                ResultContentView(userQuery: queryText)
            } label: { EmptyView() }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - SearchView_Previews
struct SearchView_Previews: PreviewProvider {
    static var item = Feed.sample
    static var category = Models.Category.sample
    
    static var previews: some View {
        SearchView(
            trendItems: [item],
            categories: [category]
        )
    }
}
