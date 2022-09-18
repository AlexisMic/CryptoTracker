//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 2/21/22.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    
    init(coin: CoinModel) {
        getcoinDetails(coin: coin)
    }
    
    func getcoinDetails(coin: CoinModel) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else {
            return
        }
        
        coinDetailSubscription = NetworkingManager.networking(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion
            , receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })

    }
    
}
