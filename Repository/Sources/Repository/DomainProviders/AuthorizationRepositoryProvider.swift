//
//  AuthorizationRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation
import Models
import Combine

public struct AuthorizationRepositoryProvider {
    
    public static var live: Self {
    //    let repository = Repository.shared
        return .init()
    }
    
    public static func preview() -> Self {
        .init()
    }
}
