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
    @State private var tabSelection: TabBarItem = .home
    @State var isModalVisible = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
                //                    .sheet(isPresented: $isModalVisible) {
                //                        OnboardingView()
                //                    }
            } else {
                // HomePageView()
                // SearchContentView()
                CustomTabBarContainerView(selection: $tabSelection) {
                    HomePageView()
                        .tabBarItem(tab: TabBarItem.home, selection: $tabSelection)
                    SearchContentView()
                        .tabBarItem(tab: TabBarItem.search, selection: $tabSelection)
                    FavoritesView()
                        .tabBarItem(tab: TabBarItem.favorites, selection: $tabSelection)
                    ProfileSettingsView()
                        .tabBarItem(tab: TabBarItem.settings, selection: $tabSelection)
                }
            }
        }
    }
}
