//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 2/13/22.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}


struct DetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overview
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalView
                    Divider()
                    additionalGrid
                    linksView
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        
        .toolbar {
            HStack {
                Text(vm.coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                CoinImageView(coin: vm.coin)
                    .frame(width: 25, height: 25)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
               // .colorScheme(.dark)
        }
        .preferredColorScheme(.dark)
        
        
    }
}

extension DetailView {
    
    private var overview: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation {
                            showFullDescription.toggle()
                        }
                        
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .foregroundColor(Color.blue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                        
                    }

                }
            }
        }
    }
    
    private var additionalView: some View {
        Text("Aditional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var linksView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.link,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = vm.subredditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
