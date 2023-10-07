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
    public var login: (_ email: String, _ password: String) -> Repository.ResponsePublisher<UserAccount>
    
    public init(login: @escaping (_: String, _: String) -> Repository.ResponsePublisher<UserAccount>) {
        self.login = login
    }
    
    public static var live: Self {
        let repository = Repository.shared
        return .init { repository.firebase(.logIn(email: $0, password: $1)) }
    }
    
    public static func preview(
        userResponse: Repository.Response<UserAccount> = .success(.sample),
        delay: RunLoop.SchedulerTimeType.Stride = 2
    ) -> Self {
        .init { _,_ in
            Just(userResponse)
                .delay(for: delay, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
