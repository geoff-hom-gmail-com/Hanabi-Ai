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
    // Could make `cards` a `lazy var`. But then, all instances of `Deck` that access `cards` would have to be `var`, even if they're just reading.
    var cards: [Card] = []

    // Each color has three 1s, two 2s/3s/4s, one 5.
    private let ones = Array(repeating: 1, count: 3)
    private let twos = Array(repeating: 2, count: 2)
    private let threes = Array(repeating: 3, count: 2)
    private let fours = Array(repeating: 4, count: 2)
    private let fives = Array(repeating: 5, count: 1)
    
    // `lazy let` won't compile. This is closest found.
    lazy private(set) var numbers = ones + twos + threes + fours + fives
    
    init() {
        
        // For each suit, make its cards. Then flatten.
        self.cards = Suit.allCases.flatMap { suit in
            numbers.map { Card(suit: suit, number: $0) }
        }
    }
    
    // Randomly reorder the deck.
    mutating func shuffle() {
        cards.shuffle()
    }
}
