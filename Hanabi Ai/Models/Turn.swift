//
//  Turn.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's turn.
///
/// A `Turn` includes the game state at the start of the turn, and the action chosen for that turn. The `action`'s resolution should be reflected in the next `Turn`.
struct Turn {
    /// The turn number, starting with 1.
    let number: Int
    
    /// The game state at the start of the turn.
//    let start: TurnStart
    
    /// The game's setup at the start of the turn.
    let setup: Setup
    
    /// The player's action for this turn; at start, `nil`.
    var action: Action?
}
