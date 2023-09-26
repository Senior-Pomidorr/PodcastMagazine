//
//  ProfileScreenDomain.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import Foundation
import SwiftUI
import Combine

enum DataLoadingStatus {
    case none
    case loading
    case error
}

enum Gender {
    case male
    case female
    case none
}

struct User: Equatable {
    var image: Image?
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: Date
    var gender: Gender
}

struct ProfileScreenDomain{
    
    //MARK: - STATE
    struct ProfileState: Equatable {
        
        var user: User
        var dataLoadingStatus: DataLoadingStatus
        
        init(
            dataLoadingStatus: DataLoadingStatus
        ) {
            self.user = .init(firstName: "", lastName: "", email: "", dateOfBirth: Date(), gender: .none)
            self.dataLoadingStatus = .none
        }
    }
    
    //MARK: - ACTION
    enum Action {
        case viewAppeared
        case profileImageDidTap(Image)
        case firstNameFieldDidTap(String)
        case lastNameFieldDidTap(String)
        case emailFieldDidTap(String)
        case dateFieldDidTap(Date)
        case genderFieldDidTap(Gender)
        case viewDisappeared
        case _getUserRequest
        case _getUserResponse(Result<ProfileState, Error>)
    }
    
    //MARK: - Dependency
    let getUser: (String) -> AnyPublisher<ProfileState, Error>
    let updateUser: (String) -> AnyPublisher<ProfileState, Error>
    
    //MARK: - Reducer
    func reduce(
        _ state: inout ProfileState,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
            
        case .viewAppeared:
            state.dataLoadingStatus = .loading
            return Just(._getUserRequest)
                .eraseToAnyPublisher()
            
        case ._getUserRequest:
            return getUser("URL")
                .map(toSuccesAction(_:))
                .catch(toFailureAction(_:))
                .eraseToAnyPublisher()
            
        case let ._getUserResponse(.success(user)):
            state = user
            state.dataLoadingStatus = .none
            
        case let ._getUserResponse(.failure(error)):
            state.dataLoadingStatus = .error
            
        case let .profileImageDidTap(image):
            break
        case let .firstNameFieldDidTap(firstName):
            break
        case let .lastNameFieldDidTap(lastName):
            break
        case let .emailFieldDidTap(email):
            break
        case let .dateFieldDidTap(date):
            break
        case let .genderFieldDidTap(gender):
            break
        case .viewDisappeared:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    func toSuccesAction(_ user: ProfileState) -> Action {
        ._getUserResponse(.success(user))
    }
    
    func toFailureAction(_ error: Error) -> Just<Action> {
        Just(._getUserResponse(.failure(error)))
    }
    
    static let live = Self(
        getUser: { _ in Empty().eraseToAnyPublisher()},
        updateUser: { _ in Empty().eraseToAnyPublisher()})
}


final class ProfileStore: ObservableObject {
    
    @Published private(set) var state: ProfileScreenDomain.ProfileState
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: Date = .now
    @Published var gender: Gender = .none
    @Published var camSubmit: Bool = false
    
    @Published private var isValidEmail = false
    
    private let reducer: (inout ProfileScreenDomain.ProfileState, ProfileScreenDomain.Action) -> AnyPublisher<ProfileScreenDomain.Action, Never>
    private var cancelable: Set<AnyCancellable> = .init()
    
    private let emailPredicate = NSCompoundPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    
    
    init(
        state: ProfileScreenDomain.ProfileState,
        reducer: @escaping (inout ProfileScreenDomain.ProfileState, ProfileScreenDomain.Action) -> AnyPublisher<ProfileScreenDomain.Action, Never>
    ) {
        self.state = state
        self.reducer = reducer
        
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { email in
                return self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &cancelable)
    }
    
    func send(_ action: ProfileScreenDomain.Action) {
        reducer(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelable)
    }
}

enum Regex: String {
    case email =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}
