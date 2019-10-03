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
    // TODO: Swap this out for currentHandIndex
    let currentHandID: UUID
    let deck: Deck
    let scores: [Suit: Int]
    let clues: Int
    let strikes: Int
    // At the turn start, there is no action (i.e., nil).
    var action: Action?
    
    init(number: Int, hands: [Hand], currentHandID: UUID, deck: Deck, clues: Int = 8, strikes: Int = 0) {
        self.number = number
        self.hands = hands
        self.currentHandID = currentHandID
        self.deck = deck
        var scores: [Suit: Int] = [:]
        for suit in Suit.allCases {
            scores[suit] = 0
        }
        self.scores = scores
        self.clues = clues
        self.strikes = strikes
    }
}

