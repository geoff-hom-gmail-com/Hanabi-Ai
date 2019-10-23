//
//  FirstPlayableAI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/22/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always plays the first playable in its hand.
///
/// If it can't play, then it discards the first card.
/// If it can't discard, then it clues.
struct FirstPlayableAI: AI {
    /// The AI's name.
    let name = "Playable 1 (plays 1st playable)"
    
    /// Returns an action for the specified setup.
    ///
    /// Play first playable. Else, discard first card.
    func action(for setup: Setup) -> Action {
        /// The current hand.
        let hand = setup.hands[setup.currentHandIndex]
        
        /// The first playable card, if any.
        if let playableCard = hand.first( where: {setup.scorePiles.nextIs($0)} ) {
            return Action(type: .play, card: playableCard, number: nil, suit: nil)
        } else {
            return DiscardFirstAI().action(for: setup)
        }
    }
}
