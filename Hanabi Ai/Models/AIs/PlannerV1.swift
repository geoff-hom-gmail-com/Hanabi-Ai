//
//  PlannerV1.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An AI that can see the deck.
///
/// TODO1a) Plays 1st playable; 1b) if another can play and scorables left ≥ deck, clues; 2) if can't discard, clues; 3a) discards unscorable card; 3b) discards duplicate among hands; 3c) discards future duplicate; 4) if no clues, discard 1st; 5) if another player can do safe play/discard, clues; 6a) if has slowest deck duplicate, discards; 6b) if another player, clues; 7a) if has slowest singleton, discards; 7b) clues.
///
/// TODOStats from 10,000 games: Avg. 24.93 (Won: 95.0%) (20–25).
struct PlannerV1: AI {
    /// The AI's name.
    let name = "Planner v1"
    
    // todo: before 6a, x) plans
    /// Summary of the AI.
    let description = "1a) plays 1st playable; 1b) if another can play and scorables left ≥ deck, clues; 2) if can't discard, clues; 3a) discards unscorable card; 3b) discards duplicate among hands; 3c) discards future hand duplicate; 4) if no clues, discard 1st; 5) if another player can do safe play/discard, clues; 6a) if has slowest deck duplicate, discards; 6b) if another player, clues; 7a) if has slowest singleton, discards; 7b) clues"
    
    /// Returns an action for the specified setup.
    func action(for setup: Setup) -> Action {
        /// The current hand.
        let hand = setup.hands[setup.currentHandIndex]

        /// Mutable copy of hands.
        var mutableHands = setup.hands
        
        mutableHands.remove(at: setup.currentHandIndex)
        
        /// All other players' cards.
        let otherHandsCards: [Card] = Array(mutableHands.joined())
        
        /// 1a) The first playable card, if any.
        if let playableCard = setup.firstPlayableCard(in: hand) {
            return Action(type: .play, card: playableCard, number: nil, suit: nil, aiStep: "1a")
            
            /// 1b) if another can play and scorables left ≥ deck, clues
            ///
            /// Checks max possible scorables left vs deck, for speed.
        } else if setup.clues > 0 &&
            ScorePile.MaxNumber * 5 - setup.scorePiles.score() >= setup.deck.count &&
            setup.firstPlayableCard(in: otherHandsCards) != nil &&
            setup.numberOfScorablesLeft() >= setup.deck.count {
            return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "1b")
            
            /// 2) if can't discard, clues
        } else if setup.clues == Setup.MaxClues {
            return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "2")
            
            /// 3a) The first card that is unscorable.
        } else if let unscorableCard = setup.firstUnscorableCard(in: hand) {
            return Action(type: .discard, card: unscorableCard, number: nil, suit: nil, aiStep: "3a")
            
            /// 3b) The first card that is duplicated in a hand (including own).
        } else if let duplicateCard = setup.firstHandDuplicateCard(in: hand) {
            return Action(type: .discard, card: duplicateCard, number: nil, suit: nil, aiStep: "3b")
                        
            /// 3c) The first card that is a future duplicate.
        } else if let futureDuplicate = setup.firstFutureHandDuplicate(in: hand) {
            return Action(type: .discard, card: futureDuplicate, number: nil, suit: nil, aiStep: "3c")
            
            /// 4) if no clues, discard 1st
            // (TODO: discard slowest deck duplicate, or slowest singleton. But for now it seems rare to have 0 clues.)
        } else if setup.clues == 0 {
            return Action(type: .discard, card: hand.first!, number: nil, suit: nil, aiStep: "4!")

            // At this point, player has at least one clue.
        } else {
            /// 5) If another player can do a safe play/discard, clue.
            if setup.firstPlayableCard(in: otherHandsCards) != nil ||
                setup.firstUnscorableCard(in: otherHandsCards) != nil || setup.hasHandDuplicates(in: otherHandsCards) || setup.firstFutureHandDuplicate(in: otherHandsCards) != nil {
                
                return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "5")
                // TODO: would try recursive action prediction, except the turn makes the next setup, and an AI can't access a turn right now.
                // I could try to expose another function for this purpose, and move part of turn's function to setup.
                // Hmm, but what a player would do and what a player could do are different.
                
                /// At this point, all players should have only deck duplicates or singletons. And we can clue or discard.
            } else {
                // todo: plan
                // for now, we'll just print all deck dups to make sure we're right.
                
                /// All players' cards.
                let handsCards: [Card] = Array(setup.hands.joined())
                
                // TODO: temp; nonTrivialDuplicates
                let nonTrivialDuplicates = setup.nonTrivialDuplicates()
                print(nonTrivialDuplicates.description)
                
                /// The deck duplicate that will take the longest to play.
                if let slowestDeckDuplicate = setup.slowestPlayableCard(cards: setup.deckDuplicates(in: handsCards)) {
                    /// 6a) if has slowest deck duplicate, discards
                    if hand.contains(slowestDeckDuplicate) {
                        return Action(type: .discard, card: slowestDeckDuplicate, number: nil, suit: nil, aiStep: "6a")
                        
                        /// 6b) if another player, clues
                    } else {
                        return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "6b")
                    }
                    
                    /// At this point, all players should have only singletons. And we can clue or discard.
                    /// The singleton that will take the longest to play.
                } else if let slowestSingleton = setup.slowestPlayableCard(cards: setup.singletons(in: handsCards)) {
                    /// 7a) if has slowest singleton, discards
                    if hand.contains(slowestSingleton) {
                        return Action(type: .discard, card: slowestSingleton, number: nil, suit: nil, aiStep: "7a!")
                        
                        /// 7b) if another player, clues
                    } else {
                        return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "7b!")
                    }
                    
                    /// Play the first card. (This step should never happen.)
                } else {
                    return Action(type: .play, card: hand.first!, number: nil, suit: nil, aiStep: "10!!!")
                }
            }
        }
    }
}
