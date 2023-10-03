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
    
    @ObservedObject var store: HomePageStore
    var categoryCellInputData: Models.Category
    
    @State private var navigateToPodcastList = false
    
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
            print("Category name =", categoryCellInputData.name)
            navigateToPodcastList = true
        }
        .background (
            NavigationLink(
                destination: PodcastListView(category: categoryCellInputData, store: store),
                isActive: $navigateToPodcastList,
                label: {
                    EmptyView()
                }
            )
        )
        .onDisappear {
           // navigateToPodcastList = false
        }
    }
}

#Preview {
    CategoryCellView(store: HomePageDomain.liveStore, categoryCellInputData: Category(id: 3, name: "Music"))
}


