//
//  APIManager.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation
import Combine
import SwiftFP
import OSLog

public struct APIManager {
    //MARK: - Private properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private var logger: Logger?
    
    public init(logger: Logger? = nil) {
        self.logger = logger
        let config = URLSessionConfiguration.default
        
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }
    
    //MARK: - Public methods
    public func request<T: Decodable>(
        method: HTTPMethod,
        _ endpoint: Endpoint
    ) -> AnyPublisher<T, APIError> {
        logger?.debug(#function)
        return Box(endpoint.url)
            .map(makeRequest(method))
            .map(addAuthHeaders(.init()))
            .flatMap(dataTaskPublisher(session))
            .tryMap(parseResponse(_:))
            .decode(type: T.self, decoder: decoder)
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
    
    func addAuthHeaders(_ secret: Secret) -> (URLRequest) -> URLRequest {
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
        logger?.debug("\(String(describing: response.response))")
        
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw MachError(.failure)
        }
        switch StatusCodes(rawValue: httpResponse.statusCode) {
        case .success: 
            return response.data
            
        case .invalidRequest:
            let message = String(data: response.data, encoding: .utf8)
            logger?.error("\(message ?? "empty")")
            throw APIError.invalidRequest(response.response.url?.description ?? "empty")
            
        case .notAuthenticated:
            let message = String(data: response.data, encoding: .utf8)
            logger?.error("\(message ?? "empty")")
            throw URLError(.userAuthenticationRequired)
            
        case .none:
            throw URLError(.badServerResponse)
        }
        
    }
}
