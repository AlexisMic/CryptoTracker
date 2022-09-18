//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 2/21/22.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var link: String? = nil
    @Published var subredditURL: String? = nil
    
    private let coinDetailsService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailsService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailsService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailsService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.link = returnedCoinDetails?.links?.homepage.first
                self?.subredditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        // Overview
        let price = coinModel.currentPrice.currencyWith6Decimals()
        let priceChangePercent = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChangePercent)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        // Additional
        let high = "$" + (coinModel.high24H?.currencyWith6Decimals() ?? "n/a")
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = "$" + (coinModel.low24H?.currencyWith6Decimals() ?? "n/a")
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = "$" + (coinModel.priceChange24H?.currencyWith6Decimals() ?? "")
        let priceChangePercent24 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: priceChangePercent24)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCap24Stat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCap24Stat, blockTimeStat, hashingStat
        ]
        
        return additionalArray
    }
    
}
