//
//  ResultContentView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//

import SwiftUI

struct ResultContentView: View {
    var rows: [GridItem] = [GridItem(.flexible())]
    let userRequestStr = "User request"
    
    var body: some View {
        VStack {
            HeaderResultView(title: userRequestStr)
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
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(height: 72)
                            }
                        } header: {
                            Text("Header")
                        }
                        
                        Section {
                            ForEach(0..<20) { index in
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(height: 72)
                            }
                        } header: {
                            Text("Header 2")
                        }
                    })
                }
                .padding(.horizontal, 33)
            }
                
        }
    }
}

#Preview {
    ResultContentView()
}

