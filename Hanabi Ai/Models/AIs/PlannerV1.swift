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
/// 1a) Plays 1st playable; 1b) if another can play and scorables left ≥ deck, clues; 2) if self can't discard, clues; 3a) discards unscorable card; 3b) discards duplicate among hands; 3c) discards future duplicate; 4) if no clues, discard 1st; 5) if another player can do safe play/discard, clues; 6a) if self has specific card not needed for max score, discards; 6b) if another player, clues; 7a) if self has slowest singleton, discards; 7b) clues.
///
/// TODOStats from 10,000 games: Avg. 24.93 (Won: 95.0%) (20–25).
struct PlannerV1: AI {
    /// The AI's name.
    let name = "Planner v1"
    
    /// Summary of the AI.
    let description = "1a) plays 1st playable; 1b) if another can play and scorables left ≥ deck, clues; 2) if self can't discard, clues; 3a) discards unscorable card; 3b) discards duplicate among hands; 3c) discards future duplicate; 4) if no clues, discard 1st; 5) if another player can do safe play/discard, clues; 6a) if self has specific card not needed for max score, discards; 6b) if another player, clues; 7a) if self has slowest singleton, discards; 7b) clues"
    
    /// The exact cards to try to score.
    ///
    /// The AI may set this at some point, as advice.
    var cardsToScore: [Card] = []

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
                
                if cardsToScore.isEmpty {
                    // TODO: make it cleaner to understand. What do I really need, and what makes the most sense to a reader?
                                  
                    print("Time to plan! Deck left: \(setup.deck.count)")

                    /// The indices of all non-trivial deck pairs.
//                    let nonTrivialDeckPairIndices2D = setup.nonTrivialDeckPairIndices2D()
//                    //indices
//                    print(nonTrivialDeckPairIndices2D)
//
//                    // ah, we also need to account for hand cards that have deck duplicates. I at least need the deck index of the duplicate.
//                    /// todo: comment
//                    let nonTrivialDeckDuplicateIndices = setup.deckDuplicateIndices(for: handsCards)
//                    // indices
//                    print(nonTrivialDeckDuplicateIndices)
//
//                    /// ?an array of arrays, each containing the indices of a non-trivial pair.
//                    ///
//                    /// If an array has only one index, then the the rest of the pair is in a hand.
//                    var nonTrivialPairIndices2D = nonTrivialDeckPairIndices2D
//
//                    /// an array of arrays, each containing the indices of a non-trivial deck duplicate.
//                    /// making this compatible
//                    let nonTrivialDeckDuplicateIndices2D = nonTrivialDeckDuplicateIndices.map{[$0]}
//
//                    nonTrivialPairIndices2D += nonTrivialDeckDuplicateIndices2D
                    
                    /// The non-trivial pairs in the deck.
                    let nonTrivialDeckPairs = setup.nonTrivialDeckPairs()

                    /// The non-trivial pairs containing a hand card and its deck duplicate, if any.
                    let nonTrivialDeckDuplicatePairs = setup.deckDuplicatePairs(for: handsCards)

                    /// The non-trivial pairs left.
                    let nonTrivialPairs = nonTrivialDeckPairs + nonTrivialDeckDuplicatePairs
                    print("Non-trivial: \(nonTrivialPairs.map{$0.0}.description)")
                                
                    /// The cards to definitely try to score.
                    let trivialCardsToScore = setup.trivialCardsToScore(nonTrivialPairs: nonTrivialPairs)
                    print("Trivial: \(trivialCardsToScore.description)")
                    // setup.trivialCardsToScore(nonTrivialPairs: nonTrivialPairs)
                    // I want to see the trivial pairs and the trivial cards. How can I do this?
                    
                    /// The max score and exact cards to try to play.
                    let maxScore = setup.maxScore(for: nonTrivialPairs, using: trivialCardsToScore)
                    print("Best score: \(maxScore.score)")
                    // todo: print indices? well in this case we'll know from the score (t1: 21; t2: 24)
                    
                    cardsToScore = maxScore.cardsToScore
                    //                    self.cardsForMaxScore = setup.hands[0]
                    
                    // these are cards; don't need them yet, but makes debug output more readable
                    // Ah, we can cheat here and use just the indices of deck duplicates, as we already played all the trivial ones.
//                    let handCardsWithNonTrivialDeckDuplicates = setup.cardsWithDeckDuplicates(in: handsCards)
//                    print(handCardsWithNonTrivialDeckDuplicates.description)
                    
                    /// The deck indices of cards that will score.
                    // TODO WILO: use the above to get the below
                    //                let scorableDeckIndices = setup.scorableDeckIndices()
                }
                
                // At this point, we have a plan, and only non-trivial deck dups or singletons.
                // If it's a card not in the plan, we discard it.
                // That leaves in step 7 only nt dups and singletons in our plan.
                // oh, but the plan chose only from nts. It didn't say which singletons to discard (or I guess which to keep). which it really should
                                
                // !!! TODO: after playing a card that is in cardsToScore, we need to remove it, so we have an accurate count of what's left to score. We can use that to determine the slowest, least-valuable card for step 7
                
                // TODO: use same closure twice below. Could make DRY. Need to look up closure syntax.
                /// 6a) if self has specific card not needed for max score, discards
                if let nonMaxCard = hand.first(where: {handCard in !cardsToScore.contains(where: {$0 === handCard}) }) {
                    return Action(type: .discard, card: nonMaxCard, number: nil, suit: nil, aiStep: "6a")
                    
                    /// 6b) if another player, clues
                } else if handsCards.contains(where: {handCard in !cardsToScore.contains(where: {$0 === handCard}) }) {
                    return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "6b")
//                }
                
                /// The card with a deck duplicate that will take the longest to play.
//                if let slowestDeckDuplicate = setup.slowestPlayableCard(cards: setup.cardsWithDeckDuplicates(in: handsCards)) {
//                    /// 6a) if self has slowest card with deck duplicate, discards
//                    if hand.contains(slowestDeckDuplicate) {
//                        return Action(type: .discard, card: slowestDeckDuplicate, number: nil, suit: nil, aiStep: "6a")
//
//                        /// 6b) if another player, clues
//                    } else {
//                        return Action(type: .clue, card: nil, number: 1, suit: nil, aiStep: "6b")
//                    }
                    
                    // TODO: this isn't great. The slowest could be a 2 because we haven't gotten the 3/4/5 yet. We instead want what's in setup.slowestLeastValuableCard(of:whileHaving:).
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
