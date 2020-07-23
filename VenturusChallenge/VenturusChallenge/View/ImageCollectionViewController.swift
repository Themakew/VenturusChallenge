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
    
    private let urlBase = "https://i.imgur.com/"
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        imagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.cellIdentifier)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.cellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let cellData = imageViewModel.responseData.data?[indexPath.row]
        
        if let coverString = cellData?.imageCover, let url = URL(string: "https://i.imgur.com/" + coverString + ".jpg") {
            cell.getImageFromURL(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
