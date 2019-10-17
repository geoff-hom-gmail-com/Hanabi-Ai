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
    /// `random`: A randomly shuffled deck.
    ///
    /// `custom`: A user-specified order for the entire deck.
    case random, custom

    /// The id for `Identifiable`.
    var id: DeckSetup { self }
    
    /// A string that describes the deck setup.
    var name: String {
        switch self {
        case .random:
            return "Random"
        case .custom:
            return "Custom"
        }
    }
}
