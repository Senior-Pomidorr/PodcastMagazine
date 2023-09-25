//
//  APIManager.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation
import Combine
import SwiftFP

public struct APIManager {
    
    public func request<T: Decodable>(
        method: HTTPMethod,
        _ endpoint: Endpoint
    ) -> AnyPublisher<T, APIError> {
        Box(endpoint.url)
            .map(makeRequest(method))
            .map(addAuthenticationHeaders(.init()))
            .flatMap(dataTaskPublisher(.shared))
            .tryMap(parseResponse(_:))
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError(APIError.map(_:))
            .eraseToAnyPublisher()
    }
}

public extension APIManager {
    //MARK: - HTTPMethod
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    //MARK: - APIError
    enum APIError: Error, LocalizedError {
        case urlError(URLError)
        case decodingError(DecodingError)
        case unknown(Error)
        
        public var errorDescription: String {
            switch self {
            case let .urlError(urlError): return urlError.localizedDescription
            case let .decodingError(decodingError): return decodingError.localizedDescription
            case let .unknown(error): return error.localizedDescription
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
    
    //MARK: - StatusCodes
    enum StatusCodes: Int {
        case success = 200
        case invalidRequest = 400
        case notAuthenticated = 401
    }
}

private extension APIManager {
    //MARK: - Response
    typealias Response = (data: Data, response: URLResponse)
    
    //MARK: - Private methods
    func makeRequest(_ method: HTTPMethod) -> (URL) -> URLRequest {
        { url in
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    func addAuthenticationHeaders(_ secret: Secret) -> (URLRequest) -> URLRequest {
        { request in
            var request = request
            request.addValue("SuperPodcastPlayer/1.3", forHTTPHeaderField: "User-Agent")
            request.addValue(secret.apiKey, forHTTPHeaderField: "X-Auth-Key")
            
            let currentTime = String().currentTime
            request.addValue(currentTime, forHTTPHeaderField: "X-Auth-Date")
            
            let hash = [secret.apiKey, secret.secretKey, currentTime].joined().sha1
            request.addValue(hash, forHTTPHeaderField: "Authorization")
            
            return request
        }
    }
    
    func dataTaskPublisher(_ session: URLSession) -> (URLRequest) -> AnyPublisher<Response, URLError> {
        { request in
            URLSession
                .DataTaskPublisher(request: request, session: session)
                .eraseToAnyPublisher()
        }
    }
    
    func parseResponse(_ response: Response) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw MachError(.failure)
        }
        switch StatusCodes(rawValue: httpResponse.statusCode) {
        case .success: return response.data
        case .invalidRequest: throw URLError(.badServerResponse)
        case .notAuthenticated: throw URLError(.userAuthenticationRequired)
        case .none: throw URLError(.badServerResponse)
        }
        
    }
}
