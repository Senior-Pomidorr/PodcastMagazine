//
//  SearchHGridView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//
import LoadableImage
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
    
    var body: some View {
        VStack(spacing: 13) {
            HStack {
                Text("Top Trend")
                    .foregroundStyle(Color.searchBarText)
                    .font(.custom(.extraBold, size: 16))
                Spacer()
                NavigationLink {
                    // TODO: NavigationLink See all
                    Text("Tab \"See all\"")
                } label: {
                    Text("See all")
                        .font(.custom(.regular, size: 16))
                        .foregroundStyle(.secondaryText)
                }
            }
            .padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 17) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink {
                            // TODO: NavigationLink Top Trend
                            Text("Destination. id: \(item.id), Category - top")
                        } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.azure2)
                                    .overlay {
                                        VStack {
                                            Text(item.title)
                                                .font(.custom(.medium, size: 14))
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.horizontal, 4)
                                    }
                            }
                            .frame(width: calculateItemWidth(), height: 84)
                        }
                        
                    }
                }
                
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
