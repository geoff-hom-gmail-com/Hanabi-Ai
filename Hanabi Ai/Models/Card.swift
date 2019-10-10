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
/// A card has a `suit` (i.e., color) and a `number`.
struct Card: Identifiable {
    /// The `ID` for `Identifiable`.
    ///
    /// In Hanabi, there are multiples of the same card (e.g., three green 1s). We need to distinguish between them.
    let id = UUID()
    
    /// The card's `Suit`.
    let suit: Suit
    
    /// The card's number (1–5).
    let number: Int
    
    /// A `String` that describes the card.
    ///
    /// For clarity (e.g., colorblindness), a card's `suit` is always noted by at least a letter. E.g., "r1", "g3".
    ///
    /// Adding foreground/font color is left to views/extensions.
    var description: String {
        "\(suit.letter)\(number)"
    }
}
