//
//  SearchScreenDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import Foundation

enum ScreenStatus {
    case none
    case loading
    case error
}

struct MocGenre: Equatable { }

struct SearchScreenDomain {
    
    enum Action {
        case viewAppeared
        case didTypeQuery(String)
        case _getTopGenresRequest(String)
        case _topGenresResponce(Result<[MocGenre], Error>)
        case _getAllGenresRequest(String)
        case _allGenresResponce(Result<[MocGenre], Error>)
    }
    
}
