//
//  ImageCollectionViewController.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import UIKit

// MARK: -

class ImageCollectionViewController: UIViewController {

    // MARK: - Properties -
    
    private var data = [ImageModel]()
    private var eventsListViewModel = EventsListViewModel(httpManager: HTTPManager(session: URLSession.shared))
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsListViewModel.getImages { [weak self] result in
            
        }
    }


}

