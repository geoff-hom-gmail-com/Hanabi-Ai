//
//  PlayableV2.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/23/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always plays the first playable in its hand.
///
/// Version after "Playable 1." Plays 1st playable; else, discards scored card; else, clues; else, discards 1st card.
/// Stats from 10,000 games: Avg. 24.0; 9–25.
struct PlayableV2: AI {
    /// The AI's name.
    let name = "Playable v2"
    
    /// Summary of the AI.
    let description = "plays 1st playable; else, discards scored card; else, clues; else, discards 1st card"
    
    /// Returns an action for the specified setup.
    func action(for setup: Setup) -> Action {
        /// The current hand.
        let hand = setup.hands[setup.currentHandIndex]
        
        /// The first playable card, if any.
        if let playableCard = hand.first( where: {setup.scorePiles.nextIs($0)} ) {
            return Action(type: .play, card: playableCard, number: nil, suit: nil)
            
            /// The first card that has already been scored by its duplicate.
        } else if (setup.clues < Setup.MaxClues), let playedCard = hand.first( where: {setup.scorePiles.alreadyHave($0)} ) {
            return Action(type: .discard, card: playedCard, number: nil, suit: nil)
        } else if setup.clues > 0 {
            return Action(type: .clue, card: nil, number: 1, suit: nil)
        } else if (setup.clues < Setup.MaxClues) {
            return Action(type: .discard, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil)
        } else {
            return Action(type: .play, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil)
        }
    }
}
