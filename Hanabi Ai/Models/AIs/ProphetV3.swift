//
//  ProphetV3.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/25/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that can see the deck.
///
/// 1) Plays 1st playable; 2) discards scored card; 3) discards duplicate among hands; 4) discards future duplicate; 5) if another player can do any of those, clues; 6) discards deck duplicate that will take longest to play; 7) if other players have only singletons, avoids clue loop: discards singleton that will take longest to play; 8) clues.
/// Stats from 10,000 games: Avg. 24.89 (16–25).
struct ProphetV3: AI {
    /// The AI's name.
    let name = "Prophet v3"
    
    /// Summary of the AI.
    let description = "1) plays 1st playable; 2) discards scored card; 3) discards duplicate among hands; 4) discards future duplicate; 5) if another player can do any of those, clues; 6) discards deck duplicate that will take longest to play; 7) if other players have only singletons, avoids clue loop: discards singleton that will take longest to play; 8) clues"
    
    /// Returns an action for the specified setup.
    func action(for setup: Setup) -> Action {
        /// The current hand.
        let hand = setup.hands[setup.currentHandIndex]

        /// 1) The first playable card, if any.
        if let playableCard = setup.firstPlayableCard(in: hand) {
            
            return Action(type: .play, card: playableCard, number: nil, suit: nil, aiStep: 1)
            
            /// 2) The first card that has already been scored by its duplicate.
        } else if setup.clues < Setup.MaxClues, let playedCard = setup.firstScoredCard(in: hand) {
            
            return Action(type: .discard, card: playedCard, number: nil, suit: nil, aiStep: 2)
            
            /// 3) The first card that is duplicated in a hand (including own).
        } else if setup.clues < Setup.MaxClues, let duplicateCard = setup.firstHandDuplicateCard(in: hand) {
            
            return Action(type: .discard, card: duplicateCard, number: nil, suit: nil, aiStep: 3)
                        
            /// 4) The first card that is a future duplicate.
        } else if setup.clues < Setup.MaxClues, let futureDuplicate = setup.firstFutureDuplicate(in: hand) {
            
            return Action(type: .discard, card: futureDuplicate, number: nil, suit: nil, aiStep: 4)
        } else {
            /// The hand index for the next player.
            let nextHandIndex = (setup.currentHandIndex == setup.hands.count - 1) ? 0 : (setup.currentHandIndex + 1)
            
            /// The next hand.
            let nextHand = setup.hands[nextHandIndex]
            
            /// 5) If another player can do any of above, clue.
            /// We don't check for max clues for next player's discard, because we'll use a clue.
            if setup.clues > 0, setup.firstPlayableCard(in: nextHand) != nil ||
                    setup.firstScoredCard(in: nextHand) != nil || setup.firstHandDuplicateCard(in: nextHand) != nil || setup.firstFutureDuplicate(in: nextHand) != nil {
                
                return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: 5)
                // TODO: would try recursive action prediction, except the turn makes the next setup, and an AI can't access a turn right now.
                // I could try to expose another function for this purpose, and move part of turn's function to setup.
                
                /// 6) The deck duplicate that will take the longest to play.
            } else if setup.clues < Setup.MaxClues, let slowestDeckDuplicate = setup.slowestPlayableCard(cards: setup.deckDuplicates(in: hand)) {
                
                return Action(type: .discard, card: slowestDeckDuplicate, number: nil, suit: nil, aiStep: 6)
                
                /// 7) If other players have only singletons, discards singleton that will take longest to play.
            } else if setup.clues < Setup.MaxClues, setup.othersHaveOnlySingletons(), let slowestSingleton = setup.slowestPlayableCard(cards: setup.singletons(in: hand)) {
                
                return Action(type: .discard, card: slowestSingleton, number: nil, suit: nil, aiStep: 7)
                
                /// 8) Clues.
            } else if setup.clues > 0 {
                return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: 8)
                
                /// 9) Play the first card. (This shouldn't be possible.)
            } else {
                return Action(type: .play, card: setup.hands[setup.currentHandIndex].first!, number: nil, suit: nil, aiStep: 9)
            }
        }
    }
}
