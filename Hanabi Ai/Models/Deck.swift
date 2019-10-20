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
typealias Deck = Array<Card>

/// A card extension for view-related functionality.
extension Deck {
    /// A string that describes a suit-ordered deck.
    static let suitOrderedString = "g1g1g1g2g2g3g3g4g4g5r1r1r1r2r2r3r3r4r4r5w1w1w1w2w2w3w3w4w4w5b1b1b1b2b2b3b3b4b4b5y1y1y1y2y2y3y3y4y4y5"
    
    /// Makes and returns the deck described by the specified string.
    ///
    /// The string should be concated card descriptions. E.g., "g1b3r3." If the string can't be parsed (TODO: make robust)
    /// (Currently, the deck will be returned as far as the parsing got. And a print statement will report the error.)
    /// Better would be describing the error in the app to the user, or catching it after entry and not letting them tap Go until fixed. But for MVP, this is okay.
    static func from(_ string: String) -> Deck {
        /// The deck.
        var deck = Deck()
        
        /// The suit for the next card.
        ///
        /// This holds the suit until the next loop, when the card is made.
        var suit = Suit.green
        
        for (index, character) in string.enumerated() {
            if index % 2 == 0 {
                guard let suit2 = Suit( rawValue: String(character) ) else {
                    print(#"Deck.from() error: Couldn't match "\#(character)" to a suit."#)
                    print("Full string: \(string)")
                    return deck
                }
                suit = suit2
            } else {
                guard let number = Int( String(character) ) else {
                    print(#"Deck.from() error: Couldn't match "\#(character)" to a number."#)
                    print("Full string: \(string)")
                    return deck
                }
                deck += [Card(suit: suit, number: number)]
            }
        }
        return deck
    }
}
