//
//  Deck.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// A deck of Hanabi cards, in an order.
struct Deck: CustomStringConvertible {
    // E.g., ["r1", "g3", "r3", …]
    var cards = [String]()
    
    // E.g., "g3r1r3…"
    var description: String {
        let compact = cards.joined(separator: "")
        return compact
    }
    
    private enum Suits: String, CaseIterable {
        case Green = "g"
        case Red = "r"
        case White = "w"
        case Blue = "b"
        case Yellow = "y"
    }
    
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
        for suit in Suits.allCases {
            for number in numbers {
                let card = "\(suit.rawValue)\(number)"
                // E.g., "g1"
                cards.append(card)
            }
        }
    }
    
    // Randomly reorder the deck.
    func shuffle() {
        
    }
    // randomly pick stuff from it.
  
}
