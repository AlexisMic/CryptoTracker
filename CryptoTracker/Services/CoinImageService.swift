//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/22/22.
//

import Foundation
import Combine
import UIKit

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private var coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let imageName: String
    private let folderName: String = "coin_images"
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.networking(url: url)
            .tryMap({ (data) -> UIImage? in
                UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion
            , receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
        
    }
    
}
