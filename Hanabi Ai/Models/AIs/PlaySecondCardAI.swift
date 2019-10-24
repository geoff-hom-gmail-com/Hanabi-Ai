//
//  PlaySecondCardAI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/21/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always plays the second card in its hand.
struct PlaySecondCardAI: AI {
    /// The AI's name.
    let name = "Impulsive 2"
    
    /// Summary of the AI.
    let description = "plays 2nd card"
    
    /// Returns an action for the specified setup.
    ///
    /// Returns the action to play the second card in its hand.
    func action(for setup: Setup) -> Action {
        Action(type: .play, card: setup.hands[setup.currentHandIndex][1], number: nil, suit: nil)
    }
}
