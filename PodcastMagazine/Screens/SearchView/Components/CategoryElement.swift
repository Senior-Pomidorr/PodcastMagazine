//
//  CategoryElement.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//
import Models
import SwiftUI

struct CategoryElement: View {

    var item: Models.Category
    
    init(
        item: Models.Category
    ) {
        self.item = item
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.randomColorForItem())
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
}

#Preview {
    CategoryElement(item: Models.Category.sample)
}
