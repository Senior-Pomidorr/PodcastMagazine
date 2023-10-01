//
//  HeaderScrollView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 01.10.23.
//

import SwiftUI

struct HeaderScrollView: View {
    let isTrend: Bool
    
    let textLeading: String
    let textTrailing: String?
    
    init(
        isTrend: Bool,
        textLeading: String,
        textTrailing: String? = nil
    ) {
        self.isTrend = isTrend
        self.textLeading = textLeading
        self.textTrailing = textTrailing
    }
    
    var body: some View {
        HStack {
            TextView(
                text: textLeading,
                size: 16,
                style: .extraBold
            )
            
            Spacer()
            
            if isTrend {
                
                NavigationLink {
                    // TODO: NavigationLink See all
                    Text("Tab \"See all\"")
                    
                } label: {
                    TextView(
                        text: textTrailing,
                        size: 16,
                        style: .regular,
                        color: .tintGrey3
                    )
                }
            }
        }
    }
}
