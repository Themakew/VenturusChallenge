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
    private var imageViewModel = ImageViewModel(httpManager: HTTPManager(session: URLSession.shared))
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewModel.getImages { [weak self] result in
            do {
                _ = try result.get()
                DispatchQueue.main.async {
//                    self?.updateUI()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

}

