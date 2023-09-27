//
//  HomePageView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI
import Models

struct HomePageView: View {

   // @State var homePageViewLoadingStatus: HomePageLoadingStatus = .none
    @StateObject var store: HomePageStore = HomePageStore(
        state: HomePageDomain.State(),
        reducer: HomePageDomain(
            getCategoryList: <#(String) -> AnyPublisher<[Category], Error>#>,
            getPodcastsList: <#(String) -> AnyPublisher<[Feed], Error>#>
        ).reduce(_:with:)
    )
    
    var body: some View {
        
        switch homePageViewLoadingStatus {
        case .none:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(1..<11) { item in
                        CategoryCellView(categoryCellData: Models.Category(id: item, name: ""))
                    }
                }
                .padding()
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
}

#Preview {
    HomePageView()
}
