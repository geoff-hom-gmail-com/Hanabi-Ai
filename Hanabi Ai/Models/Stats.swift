//
//  Stats.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/23/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// The stats from playing multiple games in a row.
///
/// This is a class (vs. struct) to conform to `ObservableObject`.
class Stats: ObservableObject {
    /// The number of games played.
    var gamesPlayed = 0
    
    /// Time to play all games; in seconds.
    ///
    /// Only this needs to be published, as it happens at the end.
    @Published var computeTime = 0.0
    
    /// The total score for all games; for computing the mean.
    var totalScore = 0
    
    /// The average score.
    var meanScore: Double {
        (gamesPlayed == 0) ? 0 : ( Double(totalScore) / Double(gamesPlayed) )
    }
    
    /// The lowest score.
    var minScore = 0
    
    /// A string describing the lowest-scoring deck.
    var minDeck = "g5r5w5b5y5…"
    
    /// The max score.
    var maxScore = 0
    
    /// A string describing the max-scoring deck.
    var maxDeck = "g1r1w1b1y1…"
}
