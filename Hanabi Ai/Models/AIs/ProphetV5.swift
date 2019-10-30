//
//  ProphetV5.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/25/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that can see the deck.
///
/// 1) Plays 1st playable; 2) if can't discard, clues; 3) discards unscorable card; 4) discards duplicate among hands; 5) discards future duplicate; 6) if no clues, discard 1st; 7) if another player can do safe play/discard, clues; 8a) if has slowest deck duplicate, discards; 8b) if another player, clues; 9a) if has slowest singleton, discards; 9b) clues.
///
/// Stats from 10,000 games: Avg. 24.89 (19–25).
struct ProphetV5: AI {
    /// The AI's name.
    let name = "Prophet v5"
    
    /// Summary of the AI.
    let description = "1) plays 1st playable; 2) if can't discard, clues; 3) discards unscorable card; 4) discards duplicate among hands; 5) discards future duplicate; 6) if no clues, discard 1st; 7) if another player can do safe play/discard, clues; 8a) if has slowest deck duplicate, discards; 8b) if another player, clues; 9a) if has slowest singleton, discards; 9b) clues"
    
    /// Returns an action for the specified setup.
    func action(for setup: Setup) -> Action {
        /// The current hand.
        let hand = setup.hands[setup.currentHandIndex]

        /// 1) The first playable card, if any.
        if let playableCard = setup.firstPlayableCard(in: hand) {
            return Action(type: .play, card: playableCard, number: nil, suit: nil, aiStep: "1")
            
            /// 2) if can't discard, clues
        } else if setup.clues == Setup.MaxClues {
            return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "2")
        
            /// 3) The first card that is unscorable.
        } else if let unscorableCard = setup.firstUnscorableCard(in: hand) {
            return Action(type: .discard, card: unscorableCard, number: nil, suit: nil, aiStep: "3")
            
            /// 4) The first card that is duplicated in a hand (including own).
        } else if let duplicateCard = setup.firstHandDuplicateCard(in: hand) {
            return Action(type: .discard, card: duplicateCard, number: nil, suit: nil, aiStep: "4")
                        
            /// 5) The first card that is a future duplicate.
        } else if let futureDuplicate = setup.firstFutureHandDuplicate(in: hand) {
            return Action(type: .discard, card: futureDuplicate, number: nil, suit: nil, aiStep: "5")
            
            /// 6) if no clues, discard 1st
            // (TODO: discard slowest deck duplicate, or slowest singleton. But for now it seems rare to have 0 clues.)
        } else if setup.clues == 0 {
            return Action(type: .discard, card: hand.first!, number: nil, suit: nil, aiStep: "6!")

        } else {
            // TODO: Make this work with all other players, not just the next player?
            /// The hand index for the next player.
            let nextHandIndex = (setup.currentHandIndex == setup.hands.count - 1) ? 0 : (setup.currentHandIndex + 1)
            
            /// The next hand.
            let nextHand = setup.hands[nextHandIndex]
            
            /// 7) If another player can do a safe play/discard, clue.
            if setup.firstPlayableCard(in: nextHand) != nil ||
                    setup.firstUnscorableCard(in: nextHand) != nil || setup.firstHandDuplicateCard(in: nextHand) != nil || setup.firstFutureHandDuplicate(in: nextHand) != nil {
                
                return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "7")
                // TODO: would try recursive action prediction, except the turn makes the next setup, and an AI can't access a turn right now.
                // I could try to expose another function for this purpose, and move part of turn's function to setup.
                
                /// At this point, all players should have only deck duplicates or singletons. And we can clue or discard.
            } else {
                /// All players' cards.
                let handsCards: [Card] = Array(setup.hands.joined())
                
                /// The deck duplicate that will take the longest to play.
                if let slowestDeckDuplicate = setup.slowestPlayableCard(cards: setup.deckDuplicates(in: handsCards)) {
                    /// 8a) if has slowest deck duplicate, discards
                    if hand.contains(slowestDeckDuplicate) {
                        return Action(type: .discard, card: slowestDeckDuplicate, number: nil, suit: nil, aiStep: "8a")
                        
                        /// 8b) if another player, clues
                    } else {
                        return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "8b")
                    }
                    
                    /// At this point, all players should have only singletons. And we can clue or discard.
                    /// The singleton that will take the longest to play.
                } else if let slowestSingleton = setup.slowestPlayableCard(cards: setup.singletons(in: handsCards)) {
                    /// 9a) if has slowest singleton, discards
                    if hand.contains(slowestSingleton) {
                        return Action(type: .discard, card: slowestSingleton, number: nil, suit: nil, aiStep: "9a!")
                        
                        /// 9b) if another player, clues
                    } else {
                        return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "9b!")
                    }
                    
                    /// Play the first card. (This step should never happen.)
                } else {
                    return Action(type: .play, card: hand.first!, number: nil, suit: nil, aiStep: "10!!!")
                }
            }
        }
    }
}
