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
            Text("Tony Stark")
                .font(.custom(.light, size: 30))
            
        }
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
