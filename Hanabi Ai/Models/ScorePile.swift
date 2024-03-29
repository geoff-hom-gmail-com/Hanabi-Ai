//
//  ScorePile.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/4/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A face-up pile for scoring a suit.
///
/// Cards are placed in consecutively increasing order—1-2-3-4-5—and the score is the top card. So, the top card is sufficient to define a score pile.
typealias ScorePile = Card

/// An extension for score piles.
extension ScorePile {
    /// The current score for the pile.
    var score: Int {
        number
    }
    
    /// The max score a pile can have.
    static let MaxNumber = 5
    
    /// Creates a score pile with the specified suit and score.
    convenience init(suit: Suit, score: Int) {
        self.init(suit: suit, number: score)
    }
    
    /// Returns a Boolean value that indicates whether the next card to score is the specified card.
    func nextIs(_ card: Card) -> Bool {
        (suit == card.suit) && (score < ScorePile.MaxNumber) && (score + 1 == card.number)
    }
    
    /// Returns a Boolean value that indicates whether the specified card has already scored.
    func alreadyHas(_ card: Card) -> Bool {
        (suit == card.suit) && (score >= card.number)
    }
}

/// An extension for an array of score piles.
extension Array where Element == ScorePile {
    /// Returns the total score for all the piles.
    func score() -> Int {
        reduce(0, {$0 + $1.number})
    }
    
    /// Returns a Boolean value that indicates whether the specified card is one of the next cards to score.
    func nextIs(_ card: Card) -> Bool {
        contains{$0.nextIs(card)}
    }
    
    /// Scores the specified card.
    ///
    /// The card goes on top of its pile, even if the play is invalid.
    mutating func score(_ card: Card) {
        /// The index of the matching score pile.
        let index = firstIndex{$0.suit == card.suit}!
        
        self[index] = card
    }
    
    /// Returns a Boolean value that indicates whether the specified card has already scored.
    func alreadyHave(_ card: Card) -> Bool {
        contains{$0.alreadyHas(card)}
    }
}
