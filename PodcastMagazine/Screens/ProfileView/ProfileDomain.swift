//
//  ProfileDomain.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

extension String {
    var trimmForbiddenSymbols: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .illegalCharacters)
    }
}

import Foundation
import Combine

enum DataLoadingStatus {
    case none
    case loading
    case error
}

struct User: Equatable {
    var imageName: String?
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: Date
    var gender: Gender
    
    init(
        imageName: String? = nil,
        firstName: String = .init(),
        lastName: String = .init(),
        email: String = .init(),
        dateOfBirth: Date = .init(),
        gender: Gender = .none
    ) {
        self.imageName = imageName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
    
    enum Gender {
        case male
        case female
        case none
    }
}

struct ProfileDomain {
    //MARK: - STATE
    struct State: Equatable {
        var name: String
        var lastName: String
        var email: String
        var dateOfBirth: Date
        var gender: User.Gender
        var dataLoadingStatus: DataLoadingStatus
        
        var buttonIsActive: Bool {
            !name.isEmpty
            && !lastName.isEmpty
            && !email.isEmpty
            && dateOfBirth != Date()
        }
        
        var user: User {
            .init(
                imageName: nil,
                firstName: name,
                lastName: lastName,
                email: email,
                dateOfBirth: dateOfBirth,
                gender: gender
            )
        }
        
        //MARK: - init(_:)
        init(
            name: String = .init(),
            lastName: String = .init(),
            email: String = .init(),
            dateOfBirth: Date = .init(),
            gender: User.Gender = .none,
            buttonIsActive: Bool = false,
            dataLoadingStatus: DataLoadingStatus = .none
        ) {
            self.name = name
            self.lastName = lastName
            self.email = email
            self.dateOfBirth = dateOfBirth
            self.gender = gender
   //         self.buttonIsActive = buttonIsActive
            
            self.dataLoadingStatus = dataLoadingStatus
        }
    }
    
    //MARK: - ACTION
    enum Action {
        case viewAppeared
 //       case profileImageDidTap(Image)
        case setFirstName(String)
        case setLastName(String)
        case setEmail(String)
        case setDateOfBirth(Date)
        case setGender(User.Gender)
        case viewDisappeared
        case _getUserRequest
        case _getUserResponse(Result<State, Error>)
    }
    
    //MARK: - Dependency
    let getUser: (String) -> AnyPublisher<State, Error>
    let updateUser: (String) -> AnyPublisher<State, Error>
    
    //MARK: - Reducer
    func reduce(
        _ state: inout State,
        with action: Action
    ) -> AnyPublisher<Action, Never> {
        switch action {
        case .viewAppeared:
            guard state.dataLoadingStatus != .loading else {
                break
            }
            state.dataLoadingStatus = .loading
            return Just(._getUserRequest)
                .eraseToAnyPublisher()
            
        case ._getUserRequest:
            return getUser("URL")
                .map(toSuccessAction(_:))
                .catch(toFailureAction(_:))
                .eraseToAnyPublisher()
            
        case let ._getUserResponse(.success(user)):
            state = user
            state.dataLoadingStatus = .none
            
        case let ._getUserResponse(.failure(error)):
            print(error)
            state.dataLoadingStatus = .error
            
        case let .setFirstName(firstName):
            state.name = firstName.trimmForbiddenSymbols
            
        case let .setLastName(lastName):
            state.lastName = lastName.trimmForbiddenSymbols
            
        case let .setEmail(email):
            state.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            
        case let .setDateOfBirth(date):
            state.dateOfBirth = date
            
        case let .setGender(gender):
            state.gender = gender
            
        case .viewDisappeared:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    func toSuccessAction(_ user: State) -> Action {
        ._getUserResponse(.success(user))
    }
    
    func toFailureAction(_ error: Error) -> Just<Action> {
        Just(._getUserResponse(.failure(error)))
    }
    
    static let live = Self(
        getUser: { _ in Empty().eraseToAnyPublisher()},
        updateUser: { _ in Empty().eraseToAnyPublisher()})
    
    static let previewStore = ProfileStore(
        state: Self.State(),
        reducer: ProfileDomain.live.reduce(_:with:)
    )
}


final class ProfileStore: ObservableObject {
    @Published private(set) var state: ProfileDomain.State
    
    private let reducer: (inout ProfileDomain.State, ProfileDomain.Action) -> AnyPublisher<ProfileDomain.Action, Never>
    private var cancelable: Set<AnyCancellable> = .init()
    
    init(
        state: ProfileDomain.State,
        reducer: @escaping (inout ProfileDomain.State, ProfileDomain.Action) -> AnyPublisher<ProfileDomain.Action, Never>
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: ProfileDomain.Action) {
        reducer(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelable)
    }
}
