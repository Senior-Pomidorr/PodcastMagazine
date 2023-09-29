//
//  ResultContentView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//

import SwiftUI

struct ResultContentView: View {
    
    let userQuery: String
    
    var rows: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HeaderResultView(title: userQuery)
                .padding(.bottom, 24)
            
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: rows,
                              alignment: .center,
                              spacing: nil,
                              pinnedViews: [],
                              content: {
                        Section {
                            ForEach(0..<3) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.regularMaterial)
                                    .frame(height: 72)
                                    .overlay {
                                        HStack {
                                            VStack {
                                                Text("Title")
                                                    .font(.title2)
                                                Text("body")
                                            }
                                            .padding()
                                            Spacer()
                                        }
                                    }
                            }
                        } header: {
                            HStack {
                                Text("Search Result")
                                    .foregroundStyle(Color.searchBarText)
                                    .font(.custom(.extraBold, size: 14))
                                Spacer()
                            }
                        }
                        
                        Section {
                            ForEach(0..<20) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.regularMaterial)
                                    .frame(height: 72)
                                    .overlay {
                                        HStack {
                                            VStack {
                                                Text("Title")
                                                    .font(.title2)
                                                Text("body")
                                            }
                                            .padding()
                                            Spacer()
                                        }
                                    }
                            }
                        } header: {
                            HStack {
                                Text("All Podcast")
                                    .foregroundStyle(Color.secondaryText)
                                    .font(.custom(.medium, size: 14))
                                Spacer()
                            }
                        }
                    })
                }
                .padding(.horizontal, 33)
            }
                
        }
        .navigationBarHidden(true)
        .padding(.top, 49)
    }
}

#Preview {
    ResultContentView(userQuery: "podlodca")
}

