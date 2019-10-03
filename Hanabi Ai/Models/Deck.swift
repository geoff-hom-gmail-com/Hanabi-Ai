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
    var cards: [Card] = []
    
    // E.g., "g3r1r3…"
//    var description: String {
//        // CustomStringConvertible seems buggy in SwiftUI (as of Xcode 11.0). So, we'll use direct calls. We want the array of cards to become an array of strings, which we can then join. So we can use map.
//        let cardDescriptions = cards.map { $0.description }
//        let compact = cardDescriptions.joined(separator: "")
//        return compact
//    }
    
    // Each color has three 1s, two 2s/3s/4s, one 5.
    private let ones = Array(repeating: 1, count: 3)
    private let twos = Array(repeating: 2, count: 2)
    private let threes = Array(repeating: 3, count: 2)
    private let fours = Array(repeating: 4, count: 2)
    private let fives = Array(repeating: 5, count: 1)
    private var numbers: [Int] {
        return ones + twos + threes + fours + fives
    }
    
    init() {
        for suit in Suit.allCases {
            for number in numbers {
                let card = Card(suit: suit, number: number)
                cards.append(card)
            }
        }
    }
    
    // Randomly reorder the deck.
    mutating func shuffle() {
        cards.shuffle()
    }
}
