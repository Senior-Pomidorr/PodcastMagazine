//
//  ResultStore.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//
import Combine
import Foundation

final class ResultStore: ObservableObject {
    @Published private(set) var state: ResultDomain.State
    
    private var reduser: (
        inout ResultDomain.State,
        ResultDomain.Action
    ) -> AnyPublisher<ResultDomain.Action, Never>
    
    private var canseleble: Set<AnyCancellable> = .init()
    
    init(
        state: ResultDomain.State,
        reduser: @escaping (inout ResultDomain.State, ResultDomain.Action) -> AnyPublisher<ResultDomain.Action, Never>
    ) {
        self.state = state
        self.reduser = reduser
    }
    
    func send(_ action: ResultDomain.Action) {
        reduser(&state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &canseleble)
    }
}
