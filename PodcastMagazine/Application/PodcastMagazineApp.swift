//
//  PodcastMagazineApp.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 25.09.23.
//

import SwiftUI
import Repository

@main
struct PodcastMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State var isModalVisible = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
//                    .sheet(isPresented: $isModalVisible) {
//                        OnboardingView()
//                    }
                } else {
                HomePageView()
                // SearchContentView()
            }
        }
    }
}
