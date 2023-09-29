//
//  PodcastMagazineApp.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI

@main
struct PodcastMagazineApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State var isModalVisible = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
                    .sheet(isPresented: $isModalVisible) {
                        OnboardingView()
                    }
            } else {
                HomePageView()
                // SearchContentView()
            }
        }
    }
}
