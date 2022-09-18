//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/24/22.
//

import SwiftUI

struct XMarkButton: View {

    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: {
            showSheet = false
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(Color.theme.accent)

        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(showSheet: .constant(true))
    }
}
