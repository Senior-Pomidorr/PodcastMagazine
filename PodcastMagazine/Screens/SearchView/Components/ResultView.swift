//
//  ResultView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 01.10.23.
//

import Models
import SwiftUI

struct ResultView: View {
    var query: String
    let items: [Feed]
    let podcastItems: [Feed]
    
    init(
        query: String,
        items: [Feed],
        podcastItems: [Feed]
    ) {
        self.query = query
        self.items = items
        self.podcastItems = podcastItems
    }
    
    private var rows: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        
        VStack {
            HeaderResultView(title: query)
            
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: rows,
                              alignment: .center,
                              spacing: nil,
                              pinnedViews: [],
                              content: {
                        Section {
                            ForEach(items, id: \.id) { item in
                                ResultCellView(
                                    isResultCell: true,
                                    item: item
                                )
                                    .frame(height: 72)
                            }
                        } header: {
                            HStack {
                                TextView(
                                    text: "Search Result",
                                    style: .extraBold
                                )
                                Spacer()
                            }
                        }
                        
                        Section {
                            ForEach(podcastItems, id: \.id) { item in
                                ResultCellView(
                                    isResultCell: false,
                                    item: item
                                )
                                    .frame(height: 72)
                            }
                        } header: {
                            HStack {
                                TextView(
                                    text: "All Podcast",
                                    style: .medium
                                )
                                Spacer()
                            }
                        }
                    })
                    .padding(.top, 24)
                }
                .padding(.horizontal, 33)
            }
        }
        .navigationBarHidden(true)
        .padding(.top, 49)
    }
}


#Preview {
    let feeds: [Feed] = Array(repeating: Feed.sample, count: 10)
    
    return ResultView(
        query: "Podlodka",
        items: feeds,
        podcastItems: feeds
    )
}
