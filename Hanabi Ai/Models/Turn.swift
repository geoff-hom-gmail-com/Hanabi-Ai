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
    var hands: [Hand]
    let currentHandID: UUID
    var deck: Deck
    var scores: [Suit: Int] = [:]
    var clues: Int = 8
    var strikes: Int = 0
    
    init(number: Int, hands: [Hand], currentHandID: UUID, deck: Deck) {
        self.number = number
        self.hands = hands
        self.currentHandID = currentHandID
        self.deck = deck
        for suit in Suit.allCases {
            scores[suit] = 0
        }
    }
}

