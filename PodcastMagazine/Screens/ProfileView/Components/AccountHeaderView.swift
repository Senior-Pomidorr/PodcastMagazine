//
//  AccountHeaderView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct AccountHeaderView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .frame(width: 48, height: 48)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.4))
                        .clipShape(Circle())
                }

                Spacer()
            }

            Text("Profile")
                .font(.headline)
        }
        .padding(.bottom, 35)
    }
}

#Preview {
    AccountHeaderView()
}
