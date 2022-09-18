//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/23/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // Create Folder if needed
        createFolderIfNeeded(folderName: folderName)
        
        // Get URL
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // Write the data on directory
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. Image name: \(imageName) Error: \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
            }
        
        return UIImage(contentsOfFile: url.path)
        
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating folder. Folder name: \(folderName) Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
