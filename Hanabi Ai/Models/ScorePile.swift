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
}
