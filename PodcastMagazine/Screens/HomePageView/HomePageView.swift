//
//  HomePageView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI
import Models

struct HomePageView: View {
    
    @StateObject var store: HomePageStore = HomePageDomain.liveStore
    @State private var selectedIndex: Int = 0
    private var maxCategories = 20
    @State var cellIdTap: Models.Category? = nil
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    HomePageHeaderView()
                    CategoryHeaderView(store: store)
                        .padding(.top)
                    
                    switch store.state.homePageLoadingStatus {
                    case .none:
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(store.state.categoryList.prefix(maxCategories)) { item in
                                    CategoryCellView(store: store, categoryCellInputData: item)
                                    
//                                    NavigationLink(
//                                        destination: PodcastListView(category: item, store: store),
//                                        label: {
//                                            CategoryCellView(
//                                                categoryCellInputData: item
//                                            )
//                                        }
//                                    )
                                    
                                }
                            }
                        }

                        
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12){
                                    ForEach(SelectedCategoryRequest.allCases.indices, id: \.self) { index in
                                        CategoriesTitleView(store: store, categoryIndex: index, selectedIndex: $selectedIndex)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(store.state.podcastsList) { podcast in
                                    PodcastCellView(store: store, podcast: podcast)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .padding(.bottom, 15)
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
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            .onAppear {
                store.send(.viewAppeared)
                store.send(.getPersistedFeeds)
            }
        }
    }
}

struct CategoryHeaderView: View {
    @ObservedObject var store: HomePageStore
    
    var body: some View {
        HStack {
            Text("Category")
                .font(.custom(.bold, size: 16))
                .foregroundStyle(Color.black)
            Spacer()
            NavigationLink {
                AllCategoryView(store: store, categories: store.state.categoryList)
            } label: {
                Text("See all")
                    .font(.custom(.light, size: 16))
                    .foregroundStyle(Color.gray)
            }
        }
    }
}

struct CategoriesTitleView: View {
    var store: HomePageStore
    var categoryIndex: Int
    @Binding var selectedIndex: Int
    
    var body: some View{
        VStack(spacing: 0) {
            Text((categoryIndex == 0 ? "🔥 " : "") + SelectedCategoryRequest.allCases[categoryIndex].rawValue.capitalized)
                .font(selectedIndex == categoryIndex ? .custom(.bold, size: 16) : .custom(.light, size: 16))
                .foregroundStyle(selectedIndex == categoryIndex ? Color.black : Color.gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                        .opacity(selectedIndex == categoryIndex ? 1 : 0)
                }
        }
        .padding(.vertical, 5)
        .onTapGesture {
            print("selected category index =", categoryIndex)
            store.send(.getSelectedCategory(SelectedCategoryRequest.allCases[categoryIndex]))
            withAnimation {
                selectedIndex = categoryIndex
            }
        }
    }
}

#Preview {
    HomePageView()
}

