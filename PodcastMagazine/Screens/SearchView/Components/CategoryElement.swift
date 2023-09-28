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
            .fill(colorByLetter(item.name))
            .overlay {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.body)
                }
                .font(.caption)
                .padding(.horizontal, 4)
            }
    }
    
    func colorByLetter(_ name: String) -> Color {
        switch name.first!.lowercased() {
        case "m": return Color.mint
        case "b": return Color.brown
        default: return Color.gray
        }
    }
}

#Preview {
    CategoryElement(item: Models.Category.sample)
}
