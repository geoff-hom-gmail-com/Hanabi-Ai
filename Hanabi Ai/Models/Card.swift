//
//  Card.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi card has a suit (i.e., color) and a number. For clarity (e.g., colorblindness), the suit is always noted by at least a letter. E.g., "r1", "g3".
struct Card: Identifiable {
    let id = UUID()
    let suit: Suit
    let number: Int
    
    // E.g., "g3". (Adding foreground color is left to Views.)
    var description: String {
        return "\(suit.rawValue)\(number)"
    }
}
