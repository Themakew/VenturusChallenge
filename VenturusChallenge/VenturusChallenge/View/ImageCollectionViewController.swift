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
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var imageViewModel = ImageViewModel(httpManager: HTTPManager(session: URLSession.shared))
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        showActivity()
        getImagesFromService()
    }
    
    // MARK: - Private Methods -
    
    private func getImagesFromService() {
        imageViewModel.getImages { result in
            do {
                _ = try result.get()
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imagesCollectionView.backgroundView = nil
                    self.updateUI()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Internal Methods -
    
    func showActivity() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        
        imagesCollectionView.backgroundView = activityIndicator
    }

    func updateUI() {
        imagesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource -

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageViewModel.responseData.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
