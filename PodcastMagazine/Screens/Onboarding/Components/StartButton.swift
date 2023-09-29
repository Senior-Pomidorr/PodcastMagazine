//
//  StartButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 29.09.2023.
//

import SwiftUI

struct StartButton: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        GeometryReader { geometry in
            Button {
                isOnboarding = false
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 64)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .white.opacity(0.9), location: 0.00),
                                    Gradient.Stop(color: .white.opacity(0.6), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                    Text("Get Started")
                        .foregroundStyle(.white)
                        .font(.custom(.semiBold, size: 20))
                }
            }
            .cornerRadius(16)
        }
    }
}


#Preview {
    StartButton()
}
