//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 2/12/22.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private var generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
