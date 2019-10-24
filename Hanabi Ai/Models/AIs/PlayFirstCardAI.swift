//
//  PlayFirstCardAI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/21/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always plays the first card in its hand.
struct PlayFirstCardAI: AI {
    /// The AI's name.
    let name = "Impulsive 1"
    
    /// Summary of the AI.
    let description = "plays 1st card"
    
    /// Returns an action for the specified setup.
    ///
    /// Returns the action to play the first card in its hand.
    func action(for setup: Setup) -> Action {
        Action(type: .play, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil)
    }
}
