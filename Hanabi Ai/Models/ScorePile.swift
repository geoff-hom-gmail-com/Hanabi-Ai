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

extension ScorePile {
    /// The current score for the pile.
    var score: Int {
        self.number
    }
}

// so insetad of aliasing a type like Card/Int/String, I'm trying to make an alias of card.number. So calling scorepile.score = card.number
//typealias score = ScorePile.number
//class ScorePile  {
//    /// The pile's suit.
//    let suit: Suit
//
//    /// The current score for the pile.
//    var score: Int
//
//    /// Creates a score pile with the specified parameters.
//    init(suit: Suit, score: Int) {
//        self.suit = suit
//        self.score = score
//    }
//}

