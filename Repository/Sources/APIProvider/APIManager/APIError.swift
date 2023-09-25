//
//  APIError.swift
//  
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation

public extension APIManager {
    enum APIError: Error, LocalizedError {
        case urlError(URLError)
        case decodingError(DecodingError)
        case unknown(Error)
        case invalidRequest(String)
        
        public var errorDescription: String {
            switch self {
            case let .urlError(urlError):
                return urlError.localizedDescription
                
            case let .decodingError(decodingError):
                return decodingError.localizedDescription
                
            case let .unknown(error):
                return error.localizedDescription
                
            case let .invalidRequest(url):
                return "Invalid parameter in url: \(url)"
            }
        }
        
        static func map(_ error: Error) -> Self {
            switch error {
            case let apiError as APIError: return apiError
            case let urlError as URLError: return .urlError(urlError)
            case let decodingError as DecodingError: return .decodingError(decodingError)
            default: return .unknown(error)
            }
        }
    }
}
