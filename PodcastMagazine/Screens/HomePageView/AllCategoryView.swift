//
//  AllCategoryView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 2.10.23.
//

import SwiftUI
import Models

struct AllCategoryView: View {
    @AppStorage("tabBar") var hideTabBar = false
    @ObservedObject var store: HomePageStore
    var categories: [Models.Category]
    var colum: [GridItem] = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: colum,
                    alignment: .center,
                    spacing: 20) {
                        ForEach(categories) { item in
                            CategoryCellView(store: store, categoryCellInputData: item)
                        }
                    }
            }
        }
        .onAppear {
            hideTabBar = false
        }
        .background(Color.white)
        .navigationTitle("All Categories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .padding(.horizontal)
    }
}

#Preview {
    HomePageView()
}
