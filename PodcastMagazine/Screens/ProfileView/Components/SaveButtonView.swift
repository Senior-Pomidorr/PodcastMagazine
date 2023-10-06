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
                .font(.custom(.medium, size: 16))
                .foregroundStyle(Color.tintGray3)
        })
        .padding()
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(Color.tintBlue3)
        .cornerRadius(24)
    }
}

#Preview {
    SaveButtonView()
}
