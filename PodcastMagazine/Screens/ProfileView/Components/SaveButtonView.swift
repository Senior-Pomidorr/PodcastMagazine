//
//  SaveButtonView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct SaveButtonView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("Save Changes")
                .font(.headline)
                .foregroundStyle(.gray)
        })
        .padding()
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(24)
    }
}

#Preview {
    SaveButtonView()
}
