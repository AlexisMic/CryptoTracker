//
//  PreviewProvider.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 10/17/21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
    
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    init() {}
    
    let homeVM = HomeViewModel()
    
    let stat1 = StatisticModel(title: "Market Cap", value: "$12.58Bn", percentageChange: 25.34)
    let stat2 = StatisticModel(title: "Total Volume", value: "1.23Tr")
    let stat3 = StatisticModel(title: "Portfolio Value", value: "$50.4k", percentageChange: -12.3)
    
    let coin = CoinModel(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 61204.008, marketCap: 1153455514361, marketCapRank: 1, fullyDilutedValuation: 1285280559791, totalVolume: 29963783028, high24H: 61949, low24H: 60504, priceChange24H: -745.456845918408, priceChangePercentage24H: -1.20333, marketCapChange24H: -7831982173.940186, marketCapChangePercentage24H: -0.67442, circulatingSupply: 18846131, totalSupply: 21000000, maxSupply: 21000000, ath: 64805, athChangePercentage: -5.3875, athDate: "2021-04-14T11:54:46.763Z", atl: 67.81, atlChangePercentage: 90320.69, atlDate: "2013-07-06T00:00:00.000Z", lastUpdated: "2021-10-17T10:32:33.466Z", sparklineIn7D: SparklineIn7D(price: [
        55732.464227926226,
        56732.474227926226,
        55782.467227926226,
        57732.134227926226,
        55739.444227926226,
        54732.424227926226,
        59732.414227926226,
        55932.894227926226,
        57732.134227926226,
        55739.444227926226,
        55132.514227926226,
        52732.494227926226,
        57732.134227926226,
        55782.394227926226,
        55532.284227926226,
        55532.284227926226,
        54732.954227926226,
        57966.84690442649
      ]), priceChangePercentage24HInCurrency: -1.203333903423205, currentHoldings: 1.5)
    
    
}
