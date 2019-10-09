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
    ///
    /// Custom: A user-specified order for the entire deck.
    case random, custom

    /// The `ID` for `Identifiable`.
    var id: DeckSetup { self }
    
    /// A `String` that describes the deck setup.
    var name: String {
        /// A `String` that holds the `return` value, to avoid multiple `return`s.
        let returnString: String
        
        switch self {
        case .random:
            returnString = "Random"
        case .custom:
            returnString = "Custom"
        }
        return returnString
    }
}
