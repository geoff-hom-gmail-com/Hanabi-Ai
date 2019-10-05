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
    // TODO: make scores an array of ScorePile? And ScorePile is a type with a color/suit and number? (like a card, but different) hmm, the current way kinda still makes sense. The main issue is when we talk about scores elsewhere, we have to remember the implementation. Yeah, let's make it [ScorePile]
    // TODO: Once implemented, we can remove any sorting (suit sorting okay,b ut the Scores willb ei the right order)
    let scorePiles: [ScorePile]
//    let scores: [Suit: Int]
    let clues: Int
    let strikes: Int
    // At the turn start, there is no action (i.e., nil).
    var action: Action?
    
    init(number: Int, hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0) {
        self.number = number
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        var scorePiles: [ScorePile] = []
        for suit in Suit.allCases {
            let scorePile: ScorePile = ScorePile(suit: suit, score: 0)
            scorePiles.append(scorePile)
        }
        self.scorePiles = scorePiles.sorted()
        self.clues = clues
        self.strikes = strikes
    }
}

