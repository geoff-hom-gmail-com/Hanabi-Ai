//
//  PlayableV3.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/23/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that always plays the first playable in its hand.
///
/// Plays 1st playable; else, discards scored card; else, discards duplicate card in hand; else, clues; else, discards duplicate card in deck; else, discards highest card.
/// Stats from 10,000 games: Avg. 24.74 (16–25).
struct PlayableV3: AI {
    /// The AI's name.
    let name = "Playable v3"
    
    /// Summary of the AI.
    let description = "plays 1st playable; else, discards scored card; else, discards duplicate card in hand; else, clues; else, discards duplicate card in deck; else, discards highest card"
    
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
            
            /// The first card that is duplicated in a hand (including own).
        } else if (setup.clues < Setup.MaxClues), let duplicateCard = hand.first( where: {setup.hands.count(for: $0) > 1} ) {
            
            return Action(type: .discard, card: duplicateCard, number: nil, suit: nil)
            
        } else if setup.clues > 0 {
            return Action(type: .clue, card: nil, number: 1, suit: nil)
            
            /// The first card that is also duplicated in the remaining deck.
        } else if (setup.clues < Setup.MaxClues), let duplicateCard = hand.first( where: { card in setup.deck.contains{$0 == card} } ) {
            
            return Action(type: .discard, card: duplicateCard, number: nil, suit: nil)
            
            /// The highest card.
        } else if (setup.clues < Setup.MaxClues), let maxCard = hand.max( by: {$0.number < $1.number} ) {

            return Action(type: .discard, card: maxCard, number: nil, suit: nil)
        } else {
            return Action(type: .play, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil)
        }
    }
}
