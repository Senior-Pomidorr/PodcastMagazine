//
//  RepositoryError.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import APIProvider

public extension Repository {
    enum RepositoryError: Error, LocalizedError {
        case urlError(URLError)
        case decodingError(DecodingError)
        case unknown(Error)
        case invalidRequest(String)
        
        public var errorDescription: String { String(describing: self) }
        
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
