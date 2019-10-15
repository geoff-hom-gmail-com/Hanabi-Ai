//
//  Turn.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's turn.
///
/// A turn includes the setup at the start of the turn, and the action chosen for that turn. The actual resolution of the action is seen in the setup of the next turn.
struct Turn {
    /// The turn number, starting with 1.
    let number: Int
    
    /// The game's setup at the start of the turn.
    let setup: Setup
    
    /// The player's action for this turn; at start, `nil`.
    var action: Action?
    
    /// Does its action and returns the resulting setup.
    func doAction() -> Setup {
        // By default, the new setup has the same parameters as now, except the current hand index.

        /// The hands for the new setup.
        var newHands = setup.hands
        
        /// The index of `hands` for the current player.
        let currentHandIndex = setup.currentHandIndex
        
        /// The index of `hands` for the next player.
        let nextHandIndex = (currentHandIndex == setup.hands.count - 1) ? 0 : (currentHandIndex + 1)

        /// The deck for the new setup.
        var newDeck = setup.deck
        
        /// The number of clues for the new setup.
        var newClues = setup.clues
        
        /// The number of strikes for the new setup.
        var newStrikes = setup.strikes
        
        /// The score piles for the new setup.
        var newScorePiles = setup.scorePiles
        
        switch action!.type {
            
        // Play: Remove card from hand. If card scores, increase score. If pile finished, gain clue (up to max). If card doesn't score, gain strike. Draw new card, if available.
        case .play:
            /// The played card.
            let card = action!.card!
            
            newHands[currentHandIndex].remove(card)
            
            /// The index of the matching score pile.
            let scorePileIndex = newScorePiles.firstIndex { $0.suit == card.suit }!
            
            if newScorePiles[scorePileIndex].nextIs(card) {
                newScorePiles[scorePileIndex] = card
                            
                // If finishing a pile, then gain a clue.
                if card.number == ScorePile.MaxNumber {
                    newClues = min(newClues + 1, Setup.MaxClues)
                }
            } else {
                newStrikes += 1
            }
            
            guard !newDeck.isEmpty else {
                // TODO: if no cards available; then have to start some sort of timer for setup.isGameOver()
                break
            }
            
            /// The top card of the deck.
            let topCard = newDeck.removeFirst()
            
            newHands[currentHandIndex] += [topCard]
            
        // Discard: Remove card from hand. Gain clue. Draw new card, if available.
        case .discard:
            /// The discarded card.
            let card = action!.card!

            newHands[currentHandIndex].remove(card)

        case .clue:
            return Setup(hands: newHands, currentHandIndex: nextHandIndex, deck: newDeck, clues: newClues, strikes: newStrikes, scorePiles: newScorePiles)
    }
    
    /// Does an action and returns the resulting setup.
    func doAction() -> Setup {
        
        
        /// The index for the current turn.
        let lastIndex = turns.count - 1
        
        turns[lastIndex] = currentTurn
        
        /// The start of the next turn.
        let nextTurnStart = currentTurn.start.did(currentTurn.action!)
        
        
    }
}
