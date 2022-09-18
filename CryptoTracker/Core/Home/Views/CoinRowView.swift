//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 10/17/21.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin:CoinModel
    let showCurrentHoldings: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showCurrentHoldings {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background)
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.accent)
            .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .padding(.leading, 6)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldinsValue.currencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0.0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.currencyWith2Decimals())
                .foregroundColor(Color.theme.accent)
                .bold()
                
            Text((coin.priceChangePercentage24H?.asPercentString())!)
                .foregroundColor((coin.priceChange24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}


struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showCurrentHoldings: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showCurrentHoldings: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

