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
            GeometryReader { geometry in
                VStack {
                    Image(OnboardingData.onboardingList[onboardingSteps].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.42, alignment: .center)
                        .padding(.vertical, 20)
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width * 0.84, height: geometry.size.height * 0.51, alignment: .center)
                            .foregroundColor(Color(red: 0.16, green: 0.51, blue: 0.95).opacity(0.37))
                            .cornerRadius(30)
                        
                        ZStack {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(OnboardingData.onboardingList[onboardingSteps].title)
                                    .font(.custom(.bold, size: 34))
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                Text(OnboardingData.onboardingList[onboardingSteps].desciption)
                                    .font(.custom(.regular, size: 20))
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                if onboardingSteps < 2 {
                                    VStack {
                                        HStack(alignment: .firstTextBaseline) {
                                            SkipButton(skipScreen: $onboardingSteps)
                                            Spacer()
                                            NextButton(onboardingSteps: $onboardingSteps)
                                        }
                                        .padding(.trailing, 14)
                                    }
                                    .padding(.bottom, 20)
                                } else {
                                    VStack(alignment: .center) {
                                        StartButton()
                                    }
                                    .padding(.horizontal, 16)
                                    .offset(y: 16)
                                }
                            }
                        }
                        .padding(.horizontal, 48)
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
