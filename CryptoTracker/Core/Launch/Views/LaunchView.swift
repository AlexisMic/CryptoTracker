//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 3/30/22.
//

import SwiftUI

struct LaunchView: View {
    
    let loadingText:[String] = "Loading portfolio...".map {String($0)}
    @State private var showLoadingText = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack {
                
                if showLoadingText {
                   
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .foregroundColor(Color.launch.accent)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastindex = loadingText.count - 1
                if counter == lastindex {
                    counter = 0
                    loops += 1
                    if loops > 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
