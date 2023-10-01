//
//  CategoryCellView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 26.09.23.
//

import SwiftUI
import Models
import LoadableImage

struct CategoryCellView: View {
    
    var categoryCellInputData: Models.Category
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(categoryCellInputData.id % 2 == 0 ? Color.color3 : Color.color1)
                .frame(width: 144, height: 200)
                .overlay {
                    LoadableImage("https://random.imagecdn.app/150/200") { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
            
            
            RoundedRectangle(cornerRadius: 12)
                .fill(categoryCellInputData.id % 2 == 0 ? Color.color4 : Color.color2)
                .frame(width: 144, height: 64)
                .overlay(
                    Text("\(categoryCellInputData.name)")
                        .font(.custom(.bold, size: 14))
                        .foregroundStyle(.black)
                        .frame(width: 144, height: 64, alignment: .center)
                        .minimumScaleFactor(0.5)
                )
        }
        .onTapGesture {
            print("press category cell")
        }
    }
}

#Preview {
    CategoryCellView(categoryCellInputData: Category(id: 3, name: "Music"))
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
