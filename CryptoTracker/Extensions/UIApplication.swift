//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/23/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
