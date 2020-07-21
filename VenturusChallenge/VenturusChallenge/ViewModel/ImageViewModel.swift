//
//  ImageViewModel.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation

// MARK: -

class EventsListViewModel {
    
    // MARK: - Properties -
    
    var events = [ImageModel]()
    var httpManagerInstance: HTTPManager?
    
    // MARK: - Init -
    
    init(httpManager: HTTPManager?) {
        if let instance = httpManager {
            httpManagerInstance = instance
        }
    }
    
    // MARK: - Internal Methods -
    
    func getImages(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        httpManagerInstance?.executeRequest(urlString: EndPoints.images.path, completionBlock: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    self.events = try decoder.decode([ImageModel].self, from: data)
                    completion(.success(try decoder.decode([ImageModel].self, from: data)))
                } catch let error {
                    completion(.failure(error))
                }
            }
        })
    }

}
