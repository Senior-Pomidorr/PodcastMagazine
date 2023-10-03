//
//  TabBarItem.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home
    case search
    case favorites
    case settings
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .search: return "search"
        case .favorites: return "favorites"
        case .settings: return "settings"
        }
    }

    static let preview: [TabBarItem] = [.home, .search, .favorites, .settings]
}
