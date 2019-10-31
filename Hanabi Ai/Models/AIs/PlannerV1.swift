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
    let description = "1a) plays 1st playable; 1b) if another can play and scorables left ≥ deck, clues; 2) if self can't discard, clues; 3a) discards unscorable card; 3b) discards duplicate among hands; 3c) discards future duplicate; 4) if no clues, discard 1st; 5) if another player can do safe play/discard, clues; 6a) if self has slowest card with deck duplicate, discards; 6b) if another player, clues; 7a) if self has slowest singleton, discards; 7b) clues"
    
    /// The cards to play for the max score.
    ///
    /// The AI may set this at some point.
    var cardsForMaxScore: [Card] = []

    /// Returns an action for the specified setup.
    mutating func action(for setup: Setup) -> Action {
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
                
                /// At this point, all players should have only cards with non-trivial deck duplicates, or singletons. And we can clue or discard.
            } else {
                /// All players' cards.
                let handsCards: [Card] = Array(setup.hands.joined())
                
                // todo: plan
                
                /// The cards to play for the max score.
                if !cardsForMaxScore.isEmpty {
                    // so, we need the exact cards, so we can use references.
                    // then if we're here, we have only non-trivial dups and singletons. we should discard the first card that's not in the list. So the list/plan needs the reference of every card to play. So it's an array of cards. It's all the cards that will score for sure.
                    print("already have plan; enact!")
                } else {
                    /// The indices of all non-trivial deck pairs.
                    let nonTrivialDeckPairIndices2D = setup.nonTrivialDeckPairIndices2D()
                    //indices
                    print(nonTrivialDeckPairIndices2D)
                    
                    // ah, we also need to account for hand cards that have deck duplicates. I at least need the deck index of the duplicate.
                    /// todo: comment
                    let nonTrivialDeckDuplicateIndices = setup.deckDuplicateIndices(for: handsCards)
                    // indices
                    print(nonTrivialDeckDuplicateIndices)
                    
                    /// ?an array of arrays, each containing the indices of a non-trivial pair.
                    ///
                    /// If an array has only one index, then the the rest of the pair is in a hand.
                    var nonTrivialPairIndices2D = nonTrivialDeckPairIndices2D
                    
                    /// an array of arrays, each containing the indices of a non-trivial deck duplicate.
                    /// making this compatible
                    let nonTrivialDeckDuplicateIndices2D = nonTrivialDeckDuplicateIndices.map{[$0]}
                    
                    nonTrivialPairIndices2D += nonTrivialDeckDuplicateIndices2D
                    
                    /// todo: rename?; hmm, we'll want it to return the optimal indices
                    /// // todo: pass in the trivial indices, so we aren't recalculating them for each branch
                    /// // though if we do this, it'll be slightly harder to pull out which branch we chose. we could flatmap the 2d, then search for the ones in the final indices. or subtract trivial indices from the final indices. or just pass back the nontrivial indices. yeah. we can pass down the trivial ones as a separate parameter.
                    /// Returns an array of non-trivial indices that results in the highest score.
                    /// Returns the cards to play for the max score.
                    let highestScoreTuple = setup.highestScore(for: nonTrivialPairIndices2D, with: [])
                    print("best indices: \(highestScoreTuple)")
                    
                    // temp; we should send it the output of highestScore(for:)
                    // ah, we don't set it in setup; we set it for the next setup
                    // uh, no. we determine it here, so it's part of this turn.
                    // we can make it part of the turn, not setup. But that doesn't make sense.
                    // I guess it can be part of the AI; like, the AI figured it out.
                    self.cardsForMaxScore = setup.hands[0]
                    
                    // these are cards; don't need them yet, but makes debug output more readable
                    // Ah, we can cheat here and use just the indices of deck duplicates, as we already played all the trivial ones.
                    let handCardsWithNonTrivialDeckDuplicates = setup.cardsWithDeckDuplicates(in: handsCards)
                    print(handCardsWithNonTrivialDeckDuplicates.description)
                    
                    /// The deck indices of cards that will score.
                    // TODO WILO: use the above to get the below
                    //                let scorableDeckIndices = setup.scorableDeckIndices()
                }
                // TODO: when this works, make it cleaner to understand. What do I really need, and what makes the most sense to a reader?
                
                
                
                /// The card with a deck duplicate that will take the longest to play.
                if let slowestDeckDuplicate = setup.slowestPlayableCard(cards: setup.cardsWithDeckDuplicates(in: handsCards)) {
                    /// 6a) if self has slowest card with deck duplicate, discards
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


