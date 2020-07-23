//
//  ImageViewModel.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation

// MARK: -

class ImageViewModel {
    
    // MARK: - Properties -
    
    var responseData = ImageModel()
    var httpManagerInstance: HTTPManager?
    var imageList: [ImageModel.Data.Image] = []
    
    // MARK: - Init -
    
    init(httpManager: HTTPManager?) {
        if let instance = httpManager {
            httpManagerInstance = instance
        }
    }
    
    // MARK: - Internal Methods -
    
    func getImages(completion: @escaping (Result<ImageModel, Error>) -> Void) {
        httpManagerInstance?.executeRequest(urlString: EndPoints.images.path, completionBlock: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    self.responseData = try decoder.decode(ImageModel.self, from: data)
                    self.setImageList(responseData: self.responseData)
                    completion(.success(try decoder.decode(ImageModel.self, from: data)))
                } catch let error {
                    completion(.failure(error))
                }
            }
        })
    }
    
    private func setImageList(responseData: ImageModel) {
        for index in 0..<(responseData.data?.count ?? 0) {
            if let images = responseData.data?[index].images?.count, images != 0 {
                for indexTwo in 0..<(images) {
                    imageList.append(responseData.data?[index].images?[indexTwo] ?? ImageModel.Data.Image())
                }
            }
            
        }
    }

}
