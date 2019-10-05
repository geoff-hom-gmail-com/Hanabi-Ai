//
//  Turn.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// Current state of the game. Can also include the current player's action.
struct Turn {
    let number: Int
    let hands: [Hand]
    let currentHandIndex: Int
    let deck: Deck
    let scorePiles: [ScorePile]
    let clues: Int
    let strikes: Int
    // At the turn start, there is no action (i.e., nil).
    var action: Action?
    
    init(number: Int, hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0) {
        self.number = number
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        self.scorePiles = Suit.allCases.sorted().map {
            ScorePile(suit: $0, score: 0)
        }
        self.clues = clues
        self.strikes = strikes
    }
}

