//
//  String.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 3/27/22.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
