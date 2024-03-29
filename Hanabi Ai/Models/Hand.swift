//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's cards.
typealias Hand = [Card]

/// An extension for hands.
extension Hand {
    /// Removes the specified card.
    ///
    /// Though we use `removeAll(where:)`, only one card should be removed, as we check for identity.
    mutating func remove(_ card: Card) {
        removeAll { $0 === card }
    }
}

/// An extension for an array of hands.
extension Array where Element == Hand {
    /// Returns the number of times the specified card is in the hands.
    func count(for card: Card) -> Int {
        reduce(0, { total, hand in
            total + hand.filter{$0 == card}.count
        })
    }
    
    /// Returns a Boolean value that indicates whether any hands contain the specified card.
    func contain(_ card: Card) -> Bool {
        contains{$0.contains(card)}
    }
}
