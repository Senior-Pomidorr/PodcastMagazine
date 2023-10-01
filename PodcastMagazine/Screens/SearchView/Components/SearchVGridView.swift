//
//  SearchVGridView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//
import Models
import SwiftUI

// MARK: - SearchVGridView
struct SearchVGridView: View {
    var items: [Models.Category]
    
    init(
        items: [Models.Category]
    ) {
        self.items = items
    }
    
    private var mocItems: [Feed] = Array(repeating: Feed.sample, count: 20)
    private var colum: [GridItem] = [
        GridItem(.flexible(), spacing: 17),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 21) {
            HeaderScrollView(
                isTrend: false,
                textLeading: "Categories"
            )
            .padding(.horizontal, 32)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: colum,
                    alignment: .center,
                    spacing: 17,
                    pinnedViews: []) {
                        ForEach(items, id: \.id) { item in
                            
                            NavigationLink {
                                // TODO: NavigationLink Category
                                Text("Destination. id: \(item.id), Category - all")
                                
                            } label: {
                                CategoryItemView(item: item)
                                    .frame(height: 84)
                            }
                        }
                    }
            }
            .padding(.horizontal, 33)
        }
    }
}


#Preview {
    SearchVGridView(items: [Models.Category.sample])
}
