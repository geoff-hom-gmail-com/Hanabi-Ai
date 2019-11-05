//
//  AI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/21/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A way to select an action in Hanabi.
///
/// Use AI instances (vs static), so they can have different perspectives.
protocol AI {
    /// The AI's name.
    var name: String { get }
    
    /// Summary of the AI.
    var description: String { get }
    
    /// The exact cards to play to the end to get the max score.
    ///
    /// The AI may set this at some point, as advice.
    var cardsToPlay: [Card] { get }

    /// The max score possible.
    ///
    /// The AI may set this at some point.
    var maxScore: Int { get }
    
    /// Resets the AI. (E.g., between games.)
    mutating func reset()
    
    /// Returns an action for the specified setup.
    mutating func action(for setup: Setup) -> Action
}

extension AI {
    var cardsToPlay: [Card] { get {[]} }
    
    var maxScore: Int { get {0} }

    mutating func reset() {}
}
