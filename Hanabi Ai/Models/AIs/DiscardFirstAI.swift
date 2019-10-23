//
//  DiscardFirstAI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/22/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always discards the first card in its hand.
///
/// If it can't discard (e.g., max clues), then it gives a clue.
struct DiscardFirstAI: AI {
    /// The AI's name.
    let name = "Discarder 1 (discards 1st card)"
    
    /// Returns an action for the specified setup.
    ///
    /// Discard first card, if possible. Else, clue.
    func action(for setup: Setup) -> Action {
        if setup.clues < Setup.MaxClues {
            return Action(type: .discard, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil)
        } else {
            // TODO: Check if this is a legal clue.
            return Action(type: .clue, card: nil, number: 1, suit: nil)
        }
    }
}
