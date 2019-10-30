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
    
    /// A string that describes a deck that can be won by playing the first card in each hand.
    static let playFirstCardString = "g1g2g3g4g5r1r2r3r4r5w1w2w3w4w5b1b2b3b4b5y1y2y3y4y5g1g1g2g3g4r1r1r2r3r4w1w1w2w3w4b1b1b2b3b4y1y1y2y3y4"
    
    /// A string that describes a deck that is tough to win. (Max 2p: 21?)
    static let toughDescription = "w5y4r4r3w1y3r5y2r2y3g3w3g1g4w4r4g1b4w4g1y5b1b4w3b5g5r3y4b2w2y1g4b1w1b2w2b1r1r1w1y1g2g3y2b3b3g2r2r1y1"
    
    /// A string that describes a deck that is tough to win. (Max 2p: 24?)
    static let tough2Description = "b2r3w4g1g3y4b4g3b5r3w5g5w2w3b4w4g4b1r1b1y2b1r4w1y5y3w2r4w1y3r1g1r1w1r2g1y1r5g4y1y1b2b3g2b3y2r2w3g2y4"
    
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
                    return deck
                }
                suit = suit2
            } else {
                guard let number = Int( String(character) ) else {
                    print(#"Deck.from() error: Couldn't match "\#(character)" to a number."#)
                    return deck
                }
                deck += [Card(suit: suit, number: number)]
            }
        }
        return deck
    }
}
