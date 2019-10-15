//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's cards.
typealias Hand = Array<Card>

/// An extension for hands.
extension Hand {
    /// Removes the specified card.
    ///
    /// Though we use `removeAll(where:)`, only one card should be removed, as we check for identity.
    mutating func remove(_ card: Card) {
        removeAll { $0 === card }
    }
}
