//
//  HeaderResultView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//

import SwiftUI

struct HeaderResultView: View {
    let title: String
    
    init(
        title: String
    ) {
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("title")
                Spacer()
                Image(systemName: "xmark.square")
                    .font(.title2)
                    .offset(x: -24)
            }
            .padding(.horizontal, 33)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .padding(.horizontal, 33)
        }
    }
}

#Preview {
    HeaderResultView(title: "User request")
}
