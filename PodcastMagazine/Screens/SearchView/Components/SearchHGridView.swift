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
                Text("Top Genres")
                    .font(.custom(.bold, size: 16))
                Spacer()
                Text("See all")
                    .font(.custom(.regular, size: 16))
                    .foregroundStyle(.secondaryText)
            }
            .padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 17) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink {
                            Text("Destination. id: \(item.id), Category - top")
                        } label: {
                            HStack {
                                LoadableImage(item.image ?? "") { image in
                                    image
                                        .resizable()
                                }
                                .scaledToFill()
                                .frame(width: calculateItemWidth(), height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
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
