//
//  RootRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation

public struct RootRepositoryProvider {
    
    public static var live: Self {
        .init()
    }
    
    public static func preview() -> Self {
        .init()
    }
}
