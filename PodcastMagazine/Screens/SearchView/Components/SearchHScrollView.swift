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
struct SearchHScrollView: View {
    var items: [Feed]
    
    var body: some View {
        VStack(spacing: 13) {
            HeaderScrollView(
                isTrend: true,
                textLeading: "Top Trend",
                textTrailing: "See all"
            )
            .padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 17) {
                    ForEach(items, id: \.id) { item in
                        
                        NavigationLink {
                            // TODO: NavigationLink Top Trend
                            Text("Destination. id: \(item.id), Top Trend")
                            
                        } label: {
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.azure2)
                                    .overlay {
                                        VStack {
                                            TextView(
                                                text: item.title,
                                                color: .white
                                            )
                                        }
                                        .padding(.horizontal, 4)
                                }
                                .frame(width: calculateItemWidth(), height: 84)
                            }
                            .frame(width: calculateItemWidth(), height: 84)
                        }
                    }
                }
                .padding(.horizontal, 33)
            }
        }
    }
    
    
    /// Считае ширину элемента в зависимости от размера экрана устройства
    /// учитывает отступы
    /// - Returns: ширина элемента CGFloat
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
    SearchHScrollView(items: [Feed.sample])
}
