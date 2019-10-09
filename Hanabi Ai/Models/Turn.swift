//
//  Turn.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's turn, including the state of the game and the player's action.
///
/// A `Turn` includes everything needed for a player/computer to choose their  action for that turn.
///
/// Only a `Turn`'s `action` can change: The resolution of the `action` should be reflected in the next `Turn`.
struct Turn {
    /// The turn number, starting with 1.
    let number: Int
    
    /// All players' hands.
    let hands: [Hand]
    
    /// The index of `hands` for the current player.
    let currentHandIndex: Int
    
    /// The cards remaining in the deck.
    let deck: Deck
    
    /// The face-up piles for scoring each suit.
    let scorePiles: [ScorePile]
    
    /// The number of clues.
    let clues: Int
    
    /// The number of strikes.
    let strikes: Int
    
    /// The player's action for this turn.
    ///
    /// A `Turn` starts with no `action` (`nil`), but it can be added later.
    var action: Action?
    
    /// Creates a `Turn` with the given turn `number`, `hands`, current player, remaining deck, score piles, `clues`, and `strikes`.
    init(number: Int, hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0) {
        self.number = number
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        // TODO: init should set scores; below works only for turn 1
        self.scorePiles = Suit.allCases.sorted().map {
            ScorePile(suit: $0, score: 0)
        }
        self.clues = clues
        self.strikes = strikes
    }
}

