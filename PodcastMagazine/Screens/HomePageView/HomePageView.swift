//
//  HomePageView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject var store: HomePageStore = HomePageDomain.liveStore
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                HomePageHeaderView()
                
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
                
                switch store.state.homePageLoadingStatus {
                case .none:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(store.state.categoryList) { item in
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
                
            }
            .padding()
        }
        .background(Color.white)
        .onAppear {
            store.send(.viewAppeared)
        }
    }
}

#Preview {
    HomePageView()
}

//VStack {
//    switch store.state.homePageLoadingStatus {
//    case .none:
//        ScrollView(.vertical, showsIndicators: false) {
//         //   HStack(spacing: 20) {
//                ForEach(store.state.podcastsList) { item in
//                    Text("\(item.id)")
//                }
//        //    }
//       //     .padding()
//        }
//    case .loading:
//        ProgressView()
//    case let .error(error):
//        VStack {
//            Text(error.localizedDescription)
//            Image(systemName: "wifi.slash")
//                .frame(width: 100, height: 100, alignment: .center)
//        }
//    }
//}
