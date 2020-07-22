//
//  ImageModel.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

// MARK: -

struct ImageModel: Codable {
    
    // MARK: - Properties -

    var data: [Data]?
    
    struct Data: Codable {
        
        var imageCover: String?
        
        private enum CodingKeys: String, CodingKey {
            case imageCover = "cover"
        }
    }
}
