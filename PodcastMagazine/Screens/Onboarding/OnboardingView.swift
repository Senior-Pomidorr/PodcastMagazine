//
//  OnboardingView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 28.09.2023.
//

import SwiftUI


struct OnboardingView: View {
    @State private var onboardingSteps = 0
    var isModalVisible = false
    var body: some View {
        TabView(selection: $onboardingSteps) {
            ForEach(0..<3, id: \.self) { step in
                GeometryReader { geometry in
                    VStack {
                        Image(OnboardingData.onboardingList[onboardingSteps].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.41)
                            .padding(.vertical, 20)
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width * 0.86, height: geometry.size.height * 0.51, alignment: .center)
                                .foregroundColor(Color(red: 0.16, green: 0.51, blue: 0.95).opacity(0.37))
                                .cornerRadius(30)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(OnboardingData.onboardingList[onboardingSteps].title)
                                    .font(.custom(.bold, size: 34))
                                    .padding(.horizontal, 16)
                                
                                Text(OnboardingData.onboardingList[onboardingSteps].desciption)
                                    .font(.custom(.regular, size: 20))
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                                
                                
                                
                                if onboardingSteps < 2 {
                                    HStack(alignment: .center) {
                                        SkipButton(skipScreen: $onboardingSteps)
                                        Spacer()
                                        NextButton(onboardingSteps: $onboardingSteps)
                                    }
                                    .padding(.trailing, 14)
                                } else {
                                    
                                    StartButton()
                                        .padding(.horizontal, 14)
                                }
                                
                            }
                            .padding(.horizontal, 48)
                            .padding(.bottom, 16)
                        }
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
