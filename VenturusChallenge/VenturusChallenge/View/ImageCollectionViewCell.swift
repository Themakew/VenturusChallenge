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
    
    private var imageCollectionViewModel = ImageCollectionViewModel(httpManager: HTTPManager(session: URLSession.shared))
    private let emptyImage = UIImage(named: "empty_image")
    
    public static var cellIdentifier = "ImageCollectionViewCell"
    
    // MARK: - View Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 4.0
        imageView.layer.cornerRadius = 10.0
        imageView.layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCollectionViewModel.task = nil
        imageView.image = nil
        
        activityIndicator.startAnimating()
    }
    
    // MARK: - Internal Methods -

    func getImageFromURL(url: String, dataType: String?, id: String) {
        if dataType?.contains("mp4") ?? false {
            setImage(image: emptyImage)
        } else {
            if let image = Utils.getImageFromDevice(imageId: id, imageName: url, storageType: .fileSystem) {
                setImage(image: image)
            } else {
                imageCollectionViewModel.getData(from: url) { result in
                    do {
                        let responseData = try result.get()
                        
                        guard !(dataType?.contains("mp4") ?? false) else {
                            self.setImage(image: self.emptyImage)
                            return
                        }
                        
                        if let imageData = UIImage(data: responseData) {
                            if url.contains("png") {
                                Utils.savePNGImageInDevice(image: imageData, imageName: id, storageType: .fileSystem)
                            } else {
                                Utils.saveJPEGImageInDevice(image: imageData, imageName: id, storageType: .fileSystem)
                            }
                        }
                        
                        self.setImage(image: UIImage(data: responseData))
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
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
