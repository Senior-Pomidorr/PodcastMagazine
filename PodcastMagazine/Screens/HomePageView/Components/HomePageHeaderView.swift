//
//  HomePageHeaderView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 26.09.23.
//

import SwiftUI

struct HomePageHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Alexandr Rodionov")
                    .font(.custom(.bold, size: 16))
                    .foregroundStyle(Color.black)
                Text("Live, write code, die")
                    .font(.custom(.light, size: 14))
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.color1)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
        }
    }
}

#Preview {
    HomePageView()
}
