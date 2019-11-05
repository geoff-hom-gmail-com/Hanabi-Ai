//
//  CardArray+Model.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/19/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An array-of-cards extension, for model-related functionality.
extension Array where Element == Card {
    /// A string that describes the concatenation of each card's description.
    var description: String {
        map{$0.description}.joined()
    }
    
    /// Returns its cards grouped by suit.
    ///
    /// Within a suit, the card order is unchanged
    var bySuit: [[Card]] {
        /// The cards, grouped by suit.
        var cards2D: [[Card]] = [[], [], [], [], []]
        
        self.forEach { card in
            cards2D[card.suit.sortIndex] += [card]
        }
        return cards2D
    }
    
    /// Returns a Boolean value that indicates whether `self` contains the specified card by reference.
    func containsExact(_ card: Card) -> Bool {
        contains{$0 === card}
    }
}
