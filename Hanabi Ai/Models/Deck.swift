//
//  Deck.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A deck of Hanabi cards, in an order.
///
/// A normal deck has five suits/colors, and each suit has ten cards: three 1s; two 2s, 3s, and 4s; and one 5.
struct Deck {
    /// The cards currently in the deck.
    ///
    /// This could be a `lazy var`. But then, all instances of `Deck` that access `cards` would have to be `var`, even if they're just reading. The current way allows more discernment.
    /// TODO: make this private? we think of the deck as the cards, so more natural language is like deck.getCard or maybe deck.pop, deck.getTopCard, not deck.cards.get
    // ditto for Hand. We think hand.description, not hand.cards.description
    var cards: [Card] = []

    /// An `Array` of 1s, as many as in a suit.
    private let suitOnes = Array(repeating: 1, count: 3)

    /// An `Array` of 2s, as many as in a suit.
    private let suitTwos = Array(repeating: 2, count: 2)
    
    /// An `Array` of 3s, as many as in a suit.
    private let suitThrees = Array(repeating: 3, count: 2)
    
    /// An `Array` of 4s, as many as in a suit.
    private let suitFours = Array(repeating: 4, count: 2)
    
    /// An `Array` of 5s, as many as in a suit.
    private let suitFives = Array(repeating: 5, count: 1)
    
    /// An `Array` of 1s thru 5s, as many as in a suit.
    ///
    /// `suitNumbers` should be a `let`, but `lazy let` won't compile. This is the closest workaround.
    lazy private(set) var suitNumbers = suitOnes + suitTwos + suitThrees + suitFours + suitFives
    
    /// Creates a `Deck` with the normal cards (5 suits), in order.
    init() {
        // For each suit, make its cards. Then flatten.
        self.cards = Suit.allCases.flatMap { suit in
            suitNumbers.map { Card(suit: suit, number: $0) }
        }
    }
    
    /// Reorders the deck randomly.
    mutating func shuffle() {
        cards.shuffle()
    }
}
