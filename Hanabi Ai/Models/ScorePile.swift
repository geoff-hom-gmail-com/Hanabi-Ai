//
//  ScorePile.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/4/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// Each suit has a score pile. Cards are placed in increasing order, and the score is the top card.
struct ScorePile  {
    let suit: Suit
    let score: Int
}
