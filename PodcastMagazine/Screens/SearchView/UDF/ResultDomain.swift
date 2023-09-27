//
//  SearchScreenResultDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation
import Models


struct ResultDomain {
    // MARK: - State
    struct State {
        var textQuery: String
        var allGenres: [Feed]
        var searchScreenStatus: ScreenStatus
        
        init(
            textQuery: String = .init(),
            allGenres: [Feed] = .init(),
            searchScreenStatus: ScreenStatus = .none
        ) {
            self.textQuery = textQuery
            self.allGenres = allGenres
            self.searchScreenStatus = searchScreenStatus
        }
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case didTypeQuery(String)
        case _getQueryGenresRequest(String)
        case _queryGenresResponce(Result<[Feed], Error>)
        case _getAllGenresRequest(String)
        case _allGenresResponce(Result<[Feed], Error>)
        case pressedSearchClearButton
        case pressedButtonBack
    }
    
    // MARK: - Dependencies
    let getQueryGenres: (String) -> AnyPublisher<[Feed], Error>
    let getAllGenres: (String) -> AnyPublisher<[Feed], Error>
    
}
