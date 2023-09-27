//
//  RepositoryError.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import APIProvider

public extension Repository {
    enum RepositoryError: Error {
        case urlError(URLError)
        case decodingError(DecodingError)
        case unknown(Error)
        case invalidRequest(String)
        
        init(apiError: APIManager.APIError) {
            switch apiError {
            case .urlError(let urlError): self = .urlError(urlError)
            case .decodingError(let decodingError): self = .decodingError(decodingError)
            case .unknown(let error): self = .unknown(error)
            case .invalidRequest(let string): self = .invalidRequest(string)
            }
        }
    }
}
