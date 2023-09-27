//
//  SearchStore.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 26.09.23.
//
import Combine
import Foundation

final class SearchStore: ObservableObject {
    @Published private(set) var state: SearchDomain.State
    
    private var reduser: (
        inout SearchDomain.State,
        SearchDomain.Action
    ) -> AnyPublisher<SearchDomain.Action, Never>
    
    // сет который хранит подписки
    private var canseleble: Set<AnyCancellable> = .init()
    
    init(
        state: SearchDomain.State,
        reduser: @escaping (inout SearchDomain.State, SearchDomain.Action) -> AnyPublisher<SearchDomain.Action, Never>
    ) {
        self.state = state
        self.reduser = reduser
    }
    
    func send(_ action: SearchDomain.Action) {
        reduser(&state, action)
        // thread, с помощью которого следует получать элементы от издателя.
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &canseleble)
    }
}
