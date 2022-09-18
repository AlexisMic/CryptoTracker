//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/24/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @Binding var showPortfolioView: Bool

    @EnvironmentObject var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantity: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if (selectedCoin != nil) {
                        portfolioInputSection
                    }
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(showSheet: $showPortfolioView)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText) { _ in
                selectedCoin = nil
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(showPortfolioView: .constant(true))
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}) {
            quantity = portfolioCoin.currentHoldings?.asNumberString() ?? ""
        } else {
            quantity = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let doubleQuantity = Double(quantity) {
            return doubleQuantity * (selectedCoin?.currentPrice ?? 0.0)
        }
        return 0.0
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text((selectedCoin?.currentPrice ?? 0.0).currencyWith6Decimals())
            }
            Divider()
            HStack {
                Text("Amount in your portfolio:")
                TextField("Ex: 1.4", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().currencyWith2Decimals())
            }
        }
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .padding()
        .animation(.none)
    }
    
    private var trailingNavBarButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
                
            Button {
                saveButtonPressed()
            } label: {
                Text("SAVE")
                    .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity) ? 1.0 : 0.0)
            }
            .disabled(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity) ? false : true)
        }
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
    
    private func saveButtonPressed() {
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantity)
        else { return }
        
        // save in portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show the checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
        }
        
        removeSelectedCoin()
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // remove checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
//        quantity = ""
    }

}
    
