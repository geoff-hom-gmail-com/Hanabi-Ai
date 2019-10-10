//
//  TurnStart.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// The game state at the start of a turn.
///
/// This includes everything needed for a player/computer to choose their action.
struct TurnStart {
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
    
    /// Creates a `TurnSetup` with the given `hands`, current player, remaining deck, score piles, `clues`, and `strikes`.
    init(hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0) {
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
