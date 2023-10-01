//
//  NextButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 29.09.2023.
//

import SwiftUI

struct NextButton: View {
    @Binding var onboardingSteps: Int
    var body: some View {
        Button {
            onboardingSteps += 1
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 85, height: 58)
                    .foregroundStyle(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .white.opacity(0.9), location: 0.00),
                                Gradient.Stop(color: .gray.opacity(0.6), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(20)
                Text("Next")
                    .foregroundStyle(.black)
                    .font(.custom(.semiBold, size: 18))
                
            }
        }
    }
}

#Preview {
    NextButton(onboardingSteps: .constant(0))
}
