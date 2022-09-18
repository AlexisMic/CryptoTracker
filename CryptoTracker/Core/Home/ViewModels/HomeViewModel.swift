//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 10/18/21.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics:[StatisticModel] = []
    
    @Published var allCoins:[CoinModel] = []
    @Published var portfolioCoins:[CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOptions = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(sortAndFilterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPorfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func sortAndFilterCoins(text: String, coins: [CoinModel], sort:SortOptions) -> [CoinModel] {
        // Filter
        var updatedCoins = filterCoins(text: text, coins: coins)
        //Sort
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOptions, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldinsValue > $1.currentHoldinsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldinsValue < $1.currentHoldinsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPorfolioCoins(allCoins: [CoinModel], portfolioEntyties:[PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntyties.first(where: { $0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats:[StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
                                .map({ $0.currentHoldinsValue})
                                .reduce(0, +)
        
        let previusValue: Double = portfolioCoins
            .map { coin in
            let currentValue = coin.currentHoldinsValue
            let percentageChange = coin.priceChangePercentage24H! / 100
            return currentValue / ( 1 + percentageChange)
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previusValue) / previusValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.currencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
