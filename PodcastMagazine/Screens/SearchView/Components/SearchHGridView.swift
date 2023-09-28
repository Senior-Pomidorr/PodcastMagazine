//
//  SearchHGridView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//
import Models
import SwiftUI

// MARK: - SearchHGridView
struct SearchHGridView: View {
    var items: [Feed]
    
    init(
        items: [Feed]
    ) {
        self.items = items
    }
    
    private let mocItems: [Feed] = Array(repeating: Feed.sample, count: 20)
    private var rows = [
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
                    ForEach(items, id: \.id) { item in
                        NavigationLink(
                            destination: Text("Destination. id: \(item.id), Category - top"),
                            label: {
                                PodcastElement(item: item)
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

#Preview {
    SearchHGridView(items: [Feed.sample])
}
