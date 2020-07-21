//
//  EndPoints.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import Foundation

enum EndPoints {
    
    case images
    
    var path: String {
        switch self {
        case .images:
            return "https://api.imgur.com/3/gallery/search/?q=cats"
        }
    }
}
