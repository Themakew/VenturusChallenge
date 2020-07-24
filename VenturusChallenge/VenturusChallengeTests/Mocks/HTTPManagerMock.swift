//
//  HTTPManagerMock.swift
//  VenturusChallengeTests
//
//  Created by Ruyther on 23/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation
@testable import VenturusChallenge

// MARK: - (Success Returning) Success Decoding Scenerio -

class HTTPManagerMockSuccessReturnOne: HTTPManager {
    
    override func executeRequest(type: HTTPMethod = .GET, urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        var data = Data()
        let model = ImageModel(data: [ImageModel.Data(imageCover: "Cover", images: [ImageModel.Data.Image(link: "link", type: "type", id: "id")])])
        
        do {
            data = try JSONEncoder().encode(model)
        } catch {
            print("Decoding error in HTTPManagerMock")
        }
        
        completionBlock(.success(data))
    }
    
    override func getData(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        completionBlock(.success(Data()))
    }
}

// MARK: - (Success Returning) Error Decoding Scenerio -

class HTTPManagerMockSuccessReturnTwo: HTTPManager {
    override func executeRequest(type: HTTPMethod = .GET, urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        let data: Data! = "[{Test:Test}]".data(using:.utf8)
        completionBlock(.success(data))
    }
    
    override func getData(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        completionBlock(.failure(HTTPError.invalidURL))
    }
}

// MARK: - Error Returning -

class HTTPManagerMockErrorReturn: HTTPManager {
    override func executeRequest(type: HTTPMethod = .GET, urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        completionBlock(.failure(NSError(domain: "Test", code: 404, userInfo: nil)))
    }
    
    override func getData(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        completionBlock(.failure(NSError(domain: "Test", code: 404, userInfo: nil)))
    }
}

