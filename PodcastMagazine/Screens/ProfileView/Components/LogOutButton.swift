//
//  LogOutButton.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 06.10.2023.
//

import SwiftUI

struct LogOutButton: View {
    
    var action: () -> Void = { }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("Log Out")
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .cornerRadius(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 1)
                )
                .foregroundColor(.blue)
        })
        .padding(.bottom)
    }
}

#Preview {
    LogOutButton()
}
