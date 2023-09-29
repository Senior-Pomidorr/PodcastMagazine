//
//  HomePageView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject var store: HomePageStore = HomePageDomain.liveStore
    @State private var selectedIndex: Int = 0
    private var maxCategories = 20
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                HomePageHeaderView()
                CategoryHeaderView()
                    .padding(.top)
                
                switch store.state.homePageLoadingStatus {
                case .none:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(store.state.categoryList.prefix(maxCategories)) { item in
                                CategoryCellView(categoryCellInputData: item)
                            }
                        }
                    }
                case .loading:
                    ProgressView()
                case let .error(error):
                    VStack {
                        Text(error.localizedDescription)
                        Image(systemName: "wifi.slash")
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                }
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12){
                            ForEach(SelectedCategoryRequest.allCases.indices, id: \.self) { index in
                                CategoriesTitleView(recipeIndex: index, selectedIndex: $selectedIndex)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(store.state.podcastsList) { podcast in
                            PodcastCellView(podcast: podcast)
                                .padding(.horizontal, 8)
                        }
                    }
                }
                
                
            }
            .padding()
        }
        .background(Color.white)
        .onAppear {
            store.send(.viewAppeared)
        }
    }
}

struct CategoryHeaderView: View {
    var body: some View {
        HStack {
            Text("Category")
                .font(.custom(.bold, size: 16))
                .foregroundStyle(Color.black)
            Spacer()
            Button(action: {
                print("Tap See all button")
            }, label: {
                Text("See all")
                    .font(.custom(.light, size: 16))
                    .foregroundStyle(Color.gray)
            })
        }
    }
}

struct CategoriesTitleView: View {
    var recipeIndex: Int
    @Binding var selectedIndex: Int
    
    var body: some View{
        VStack(spacing: 0) {
            Text((recipeIndex == 0 ? "🔥 " : "") + SelectedCategoryRequest.allCases[recipeIndex].rawValue.capitalized)
                .font(selectedIndex == recipeIndex ? .custom(.bold, size: 16) : .custom(.light, size: 16))
                .foregroundStyle(selectedIndex == recipeIndex ? Color.black : Color.gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                        .opacity(selectedIndex == recipeIndex ? 1 : 0)
                }
        }
        .padding(.vertical, 5)
        .onTapGesture {
            withAnimation {
                selectedIndex = recipeIndex
            }
            // go to internet
        }
    }
}

#Preview {
    HomePageView()
}

