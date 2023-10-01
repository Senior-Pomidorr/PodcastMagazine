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
    
    var body: some Scene {
        WindowGroup {
            HomePageView()
           // SearchContentView()
        }
    }
    
}
