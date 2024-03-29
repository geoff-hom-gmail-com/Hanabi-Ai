//
//  DeckSetup.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A way to set up the deck; e.g., randomly, or with a custom order.
enum DeckSetup: CaseIterable, Identifiable {
    // TODO: later, could have options like "hard," "easy"; will have to figure out how to make those
    /// The deck-setup options.
    ///
    /// Random: A randomly shuffled deck.
    /// Suit-Ordered: Cards in suit order. (For "empty" game.)
    /// Tough: Cards in an unfortunate order.
    /// Custom: A user-specified order for the entire deck.
    case random, suitOrdered, test1, test2, tough, tough2, custom

    /// The id for `Identifiable`.
    var id: DeckSetup { self }
    
    /// A string that describes the deck setup.
    var name: String {
        switch self {
        case .random:
            return "Random"
        case .suitOrdered:
            // This hyphen is non-breaking.
            return "Suit‑Ordered"
        case .test1:
            return "Test 1"
        case .test2:
            return "Test 2"
        case .tough:
            return "Tough"
        case .tough2:
            return "Tough2"
        case .custom:
            return "Custom"
        }
    }
}
