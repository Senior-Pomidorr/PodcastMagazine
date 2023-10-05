//
//  ProfileRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 05.10.2023.
//

import Foundation
import Models

public struct ProfileRepositoryProvider {
    public var getCurrentUser: () -> Repository.ResponsePublisher<UserAccount>
    public var changePasswordRequest: (String) -> Repository.ResponsePublisher<Void>
    public var logOut: () -> Repository.ResponsePublisher<Void>
    
    
}
