//
//  Card.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi card.
///
/// A card has a suit (i.e., color) and a number. There are multiples of some cards (e.g., three green 1s).

class Card {
    /// The card's suit.
    let suit: Suit
    
    /// The card's number (1–5).
    let number: Int
    
    /// A string that describes the card.
    ///
    /// For clarity (e.g., colorblindness), a card's suit is always noted by at least a letter. E.g., "r1", "g3".
    ///
    /// Adding foreground/font color is left to views/extensions.
    var description: String {
        "\(suit.letter)\(number)"
    }
    
    /// Creates a card with the specified parameters.
    init(suit: Suit, number: Int) {
        self.suit = suit
        self.number = number
    }
}
