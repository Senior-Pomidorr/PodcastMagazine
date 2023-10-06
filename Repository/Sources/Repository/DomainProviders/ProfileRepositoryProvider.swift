//
//  ProfileRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 05.10.2023.
//

import Foundation
import Models
import Combine

public struct ProfileRepositoryProvider {
    public var getCurrentUser: () -> Repository.ResponsePublisher<UserAccount>
    public var updateUser: (UserAccount) throws -> UserAccount
    public var changePasswordRequest: (String) -> Repository.ResponsePublisher<Void>
    public var logOut: () -> Repository.ResponsePublisher<Void>
    
    public static var live: Self {
        let repository = Repository.shared
        return .init(
            getCurrentUser: { repository.firebase(.currentUser) },
            updateUser: { try repository.addPersisted($0) },
            changePasswordRequest: repository.firebaseResetPassword,
            logOut: repository.firebaseLogout
        )
    }
    
    
}
