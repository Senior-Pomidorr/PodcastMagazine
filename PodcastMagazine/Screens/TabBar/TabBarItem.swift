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
        case .home: return "House"
        case .search: return "Search"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }

    static let preview: [TabBarItem] = [.home, .search, .favorites, .settings]
}
