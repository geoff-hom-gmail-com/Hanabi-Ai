//
//  Deck.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A deck of Hanabi cards, in an order.
///
/// A normal deck has five suits/colors, and each suit has ten cards: three 1s; two 2s, 3s, and 4s; and one 5.
typealias Deck = Array<Card>

/// A card extension for view-related functionality.
extension Deck {
    /// A string that describes a suit-ordered deck.
    static let suitOrderedString = "g1g1g1g2g2g3g3g4g4g5r1r1r1r2r2r3r3r4r4r5w1w1w1w2w2w3w3w4w4w5b1b1b1b2b2b3b3b4b4b5y1y1y1y2y2y3y3y4y4y5"
}
