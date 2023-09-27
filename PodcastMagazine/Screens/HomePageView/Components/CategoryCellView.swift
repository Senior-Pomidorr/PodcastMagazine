//
//  CategoryCellView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 26.09.23.
//

import SwiftUI
import Models

struct CategoryCellView: View {
    
    var categoryCellData: Models.Category
    
    var body: some View {
        ZStack(alignment: .bottom) {

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.random())
                .frame(width: 150, height: 200)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.random())
                .frame(width: 150, height: 60)
                .padding(.bottom, 0)
            
            Text("\(categoryCellData.id)")
                .foregroundStyle(.white)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    CategoryCellView(categoryCellData: Category(id: 1, name: "Music"))
}

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0..<1),
            green: Double.random(in: 0..<1),
            blue: Double.random(in: 0..<1)
        )
    }
}
