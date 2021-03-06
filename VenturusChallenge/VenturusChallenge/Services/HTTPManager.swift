//
//  HTTPManager.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation

// MARK: - Enum -

enum HTTPError: Error {
    case invalidURL
    case invalidResponse
}

enum HTTPMethod: String {
    case GET = "GET"
}

// MARK: - LocalizedError -

extension HTTPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "service_url_error".text()
        case .invalidResponse:
            return "service_error".text()
        }
    }
}

// MARK: - Protocol -

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func dataTask(with request: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

// MARK: -

class HTTPManager {
    
    // MARK: - Properties -
    
    private let session: URLSessionProtocol
    
    var task: URLSessionDataTaskProtocol?
    
    // MARK: - Init -
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: - Internal Methods -
    
    func executeRequest(type: HTTPMethod = .GET, urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        let requestDictionary = createURLRequest(type: type, url: url)
        
        let task = session.dataTask(with: requestDictionary) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse))
                    return
            }

            completionBlock(.success(responseData))
        }
        task.resume()
    }
    
    func getData(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse))
                    return
            }

            completionBlock(.success(responseData))
        }
        task?.resume()
    }
    
    // MARK: - Private Methods -
    
    private func createURLRequest(type: HTTPMethod, url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.rawValue
        
        urlRequest.setValue("Client-ID 1ceddedc03a5d71", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

