//
//  Deck.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A deck of Hanabi cards, in an order.
struct Deck {
    /// The cards currently in the deck.
    ///
    /// This could be a `lazy var`. But then, all instances of `Deck` that access `cards` would have to be `var`, even if they're just reading. The current way allows more discernment.
    /// TODO: make this private? we think of the deck as the cards, so more natural language is like deck.getCard or maybe deck.pop, deck.getTopCard, not deck.cards.get
    // ditto for Hand. We think hand.description, not hand.cards.description
    var cards: [Card] = []

    /// The cards in the deck at the start.
    ///
    /// Each color has three 1s; two 2s, 3s, and 4s; and one 5. Ten cards per color.
    
    /// An `Array` of three `1`s, as there are three `1`s of each color.
    private let ones = Array(repeating: 1, count: 3)
    
    /// An `Array` of two `2`s.
    private let twos = Array(repeating: 2, count: 2)
    
    /// An `Array` of two `3`s.
    private let threes = Array(repeating: 3, count: 2)
    
    /// An `Array` of two `4`s.
    private let fours = Array(repeating: 4, count: 2)
    
    /// An `Array` of one `5`.
    private let fives = Array(repeating: 5, count: 1)
    
    /// An `Array` of `1`s thru `5`s, as there are that many of each number for each color.
    ///
    /// `numbers` should be a `let`, but `lazy let` won't compile. This is the closest workaround.
    lazy private(set) var numbers = ones + twos + threes + fours + fives
    
    /// Creates a `Deck` with the normal cards (5 colors), in order.
    init() {
        // For each suit, make its cards. Then flatten.
        self.cards = Suit.allCases.flatMap { suit in
            numbers.map { Card(suit: suit, number: $0) }
        }
    }
    
    /// Reorders the deck randomly.
    mutating func shuffle() {
        cards.shuffle()
    }
}
