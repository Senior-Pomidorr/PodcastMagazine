//
//  CategoryElement.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//
import Models
import SwiftUI

struct CategoryElement: View {
    //    private let mocItem: Feed = Feed.sample
    var item: Models.Category
    
    init(
        item: Models.Category
    ) {
        self.item = item
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(randomColor())
            .overlay {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.custom(.medium, size: 14))
                        .foregroundStyle(.white)
                }
                .font(.caption)
                .padding(.horizontal, 4)
            }
    }
    
    func randomColor() -> Color {
        let colors: [Color] = [
            .azure1, .azure2, .beige1, .beige2,
            .beige3, .beige4, .lilac1, .lilac2
        ]
        return colors.randomElement()!
    }
}

#Preview {
    CategoryElement(item: Models.Category.sample)
}
