//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/29/22.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading the container: \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: Public func
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, newAmount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    // MARK: Private func
    
    private func getPortfolio() {
        
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching the Portfolios: \(error)")
        }
        
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, newAmount: Double) {
        entity.amount = newAmount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving coin to Portfolio: \(error)")
            
        }
    }
    
    private func applyChanges() {
        save()
        
        // Se forem muitas entities pode adicionar direto no array savedEntities, sem outro Fetch Request
        getPortfolio()
    }
}
