//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's cards.
struct Hand {
    /// The cards.
    var cards: [Card] = []
    
    /// Adds `card` to `self`.
    mutating func add(_ card: Card) {
        cards += [card]
    }
    
    /// Removes `card` from `self`.
    mutating func remove(_ card: Card) {
        cards.removeAll {
            $0.id == card.id
        }
    }
}
