//
//  Utils.swift
//  VenturusChallenge
//
//  Created by Ruyther on 22/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import UIKit

// MARK: - Enum -

enum StorageType {
    case fileSystem
}

// MARK: -

class Utils {
    
    // MARK: - Static Methods -
    
    static func alert(_ viewController: UIViewController, title: String? = nil, _ message: String, btnLabel: String? = nil, completion: (() -> ())? = nil, onOK: (() -> ())? = nil) {
        DispatchQueue.main.async {
            let cancelButton = UIAlertAction(title: btnLabel ?? "ok".text(), style: .default, handler: { action in
                onOK?()
            })
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(cancelButton)
            
            viewController.present(alert, animated: true, completion: completion)
        }
    }
    
    static func savePNGImageInDevice(image: UIImage, imageName: String, storageType: StorageType) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let pngRepresentation = image.pngData() {
                switch storageType {
                case .fileSystem:
                    if !FileManager().fileExists(atPath: self.getFilePath(imageName: imageName, type: ".png")?.path ?? "") {
                        if let filePath = self.getFilePath(imageName: imageName, type: ".png") {
                            do {
                                try pngRepresentation.write(to: filePath,
                                                            options: .atomic)
                                print("Image \(imageName) saved.")
                                print(filePath)
                            } catch let error {
                                print("Saving PNG file resulted in error: ", error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func saveJPEGImageInDevice(image: UIImage, imageName: String, storageType: StorageType) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let jpegRepresentation = image.jpegData(compressionQuality: 1.0) {
                switch storageType {
                case .fileSystem:
                    if !FileManager().fileExists(atPath: self.getFilePath(imageName: imageName, type: ".jpg")?.path ?? "") {
                        if let filePath = self.getFilePath(imageName: imageName, type: ".jpg") {
                            do {
                                try jpegRepresentation.write(to: filePath,
                                                            options: .atomic)
                                print("Image \(imageName) saved.")
                                print(filePath)
                            } catch let error {
                                print("Saving JPEG file resulted in error: ", error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getImageFromDevice(imageId: String, imageName: String, storageType: StorageType) -> UIImage? {
        var imageFromDevice: UIImage?
        let type = imageName.contains("png") ? ".png" : ".jpg"
        
        switch storageType {
        case .fileSystem:
            if let filePath = getFilePath(imageName: imageId, type: type),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                imageFromDevice = image
            }
        }
        
        return imageFromDevice
    }
    
    private static func getFilePath(imageName: String, type: String) -> URL? {
        let filename = imageName + type
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        
        return documentURL.appendingPathComponent(filename)
    }
}
