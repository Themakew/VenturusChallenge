//
//  ImageCollectionViewModel.swift
//  VenturusChallenge
//
//  Created by Ruyther on 22/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation

class ImageCollectionViewModel {
    
    // MARK: - Properties -
    
    var httpManagerInstance: HTTPManager?
    var task: URLSessionDataTaskProtocol?
    
    // MARK: - Init -
    
    init(httpManager: HTTPManager?) {
        if let instance = httpManager {
            httpManagerInstance = instance
            task = httpManagerInstance?.task
        }
    }
    
    // MARK: - Internal Methods -
    
    func getData(from url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        httpManagerInstance?.getData(urlString: url, completionBlock: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data))
            }
        })
    }
}
