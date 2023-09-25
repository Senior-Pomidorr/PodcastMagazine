//
//  APIManager.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation
import Combine

public struct APIManager {
    

}

public extension APIManager {
    //MARK: - StatusCodes
    enum StatusCodes: Int {
        case success = 200
        case invalidRequest = 400
        case notAuthenticated = 401
    }
}
