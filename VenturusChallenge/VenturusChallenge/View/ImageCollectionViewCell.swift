//
//  ImageCollectionViewCell.swift
//  VenturusChallenge
//
//  Created by Ruyther on 21/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import UIKit

// MARK: -

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties -
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imageCollectionViewModel = ImageCollectionViewModel()
    
    public static var cellIdentifier = "ImageCollectionViewCell"
    
    // MARK: - View Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10.0
        imageView.layer.cornerRadius = 4.0
        
        activityIndicator.startAnimating()
    }
    
    // MARK: - Internal Methods -

    func getImageFromURL(url: URL) {
        imageCollectionViewModel.getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else {
                self.setImage(image: UIImage(named: "empty_image"))
                return
            }
            
            self.setImage(image: UIImage(data: data))
        }
    }
    
    // MARK: - Private Methods -
    
    private func setImage(image: UIImage?) {
        DispatchQueue.main.async() {
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}
