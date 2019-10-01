//
//  Turn.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// Current state of the game. May also include the current player's action.
struct Turn {
    // includes hands at start of turn, remaining deck, score piles, clues, strikes
    
    var hands: [Hand]
    var deck: Deck
    var scores: [Suit: Int] = [:]
    var clues: Int = 8
    var strikes: Int = 0
    
    init(hands: [Hand], deck: Deck) {
        self.hands = hands
        self.deck = deck
        for suit in Suit.allCases {
            scores[suit] = 0
        }
    }
}

