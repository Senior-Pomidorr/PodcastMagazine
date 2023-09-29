//
//  OnboardingView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 28.09.2023.
//

import SwiftUI


struct OnboardingView: View {
    @State private var onboardingSteps = 0
    var body: some View {
        TabView {
            VStack {
                Image(OnboardingData.onboardingList[onboardingSteps].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 309, height: 309, alignment: .center)
                    .padding(.bottom, 20)
                ZStack {
                    Rectangle()
                        .frame(width: 309, height: 400, alignment: .center)
                        .foregroundColor(Color(red: 0.16, green: 0.51, blue: 0.95).opacity(0.37))
                        .cornerRadius(30)
                    VStack(alignment: .leading) {
                        Text(OnboardingData.onboardingList[onboardingSteps].title)
                            .font(.system(size: 34))
                            .padding(.bottom, 16)
                        Text(OnboardingData.onboardingList[onboardingSteps].desciption)
                            .font(.system(size: 22))
                        VStack {
                            HStack(alignment: .center) {
                                SkipButton(skipScreen: $onboardingSteps)
                                Spacer()
                                NextButton(onboardingSteps: $onboardingSteps)
                            }
                        }
                
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 60)
                    
                    VStack {
                        
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    OnboardingView()
}
