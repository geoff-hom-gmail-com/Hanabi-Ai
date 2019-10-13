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
/// Cards are placed in consecutively increasing order—1-2-3-4-5—and the score is the top card.
class ScorePile  {
    /// The pile's suit.
    let suit: Suit
    
    /// The current score for the pile.
    var score: Int
    
    /// Creates a score pile with the specified parameters.
    init(suit: Suit, score: Int) {
        self.suit = suit
        self.score = score
    }
}
