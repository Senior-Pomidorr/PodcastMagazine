//
//  SearchScreenResultDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Combine
import Foundation


struct SearchScreenResultDomain {
    // MARK: - State
    struct State: Equatable {
        var textQuery: String
        var allGenres: [MocGenre]
        var searchScreenStatus: ScreenStatus
    }
    
    // MARK: - Action
    enum Action {
        case viewAppeared
        case didTypeQuery(String)
        case _getQueryGenresRequest(String)
        case _queryGenresResponce(Result<[MocGenre], Error>)
        case _getAllGenresRequest(String)
        case _allGenresResponce(Result<[MocGenre], Error>)
        case pressedSearchClearButton
        case pressedButtonBack
    }
    
    // MARK: - Dependencies
    let getQueryGenres: (String) -> AnyPublisher<[MocGenre], Error>
    let getAllGenres: (String) -> AnyPublisher<[MocGenre], Error>
    
}
