//
//  Setup.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi game's setup at the start of a turn.
///
/// This includes everything needed for a player/computer to choose their action. For example, past clues.
struct Setup {
    /// All players' hands.
    let hands: [Hand]
    
    /// The index of `hands` for the current player.
    let currentHandIndex: Int
    
    /// The cards remaining in the deck.
    let deck: Deck
    
    /// The number of clues.
    let clues: Int
    
    /// The number of strikes.
    let strikes: Int
    
    /// The face-up piles for scoring each suit, in suit order.
    let scorePiles: [ScorePile]
    
    /// An `Array` of all `ScorePile`s, with score set to 0 and in suit order.
    private static let InitialScorePiles = Suit.allCases.sorted().map {
        ScorePile(suit: $0, score: 0)
    }
    
    /// Creates a `TurnStart` with the given `hands`, current player, remaining deck, score piles, `clues`, and `strikes`.
    init(hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0, scorePiles: [ScorePile] = InitialScorePiles) {
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        self.clues = clues
        self.strikes = strikes
        self.scorePiles = scorePiles
    }
    
    /// Returns the `TurnStart` that results from doing the given `action`.
    func did(_ action: Action) -> Setup {
        // By default, the new `TurnStart` has the same parameters as `self`, except the current hand index.
        
        /// The hands for the new `TurnStart`.
        var newHands = hands
        
        // TODO: this is definitely rotating
        /// The current hand index for the new `TurnStart`.
//        var newCurrentHandIndex = currentHandIndex
        
        /// The deck for the new `TurnStart`.
        var newDeck = deck
        
        /// The number of clues for the new `TurnStart`.
        var newClues = clues
        
        /// The number of strikes for the new `TurnStart`.
        var newStrikes = strikes
        
        /// The score piles for the new `TurnStart`.
        var newScorePiles = scorePiles
        
        switch action.type {
        case .play:
            /// The played card.
            let card = action.card!
            
            // this could be removeCardFromCurrentPlayerHand(card), removeFromCurrentPlayerHand
            newHands[currentHandIndex].remove(card)
            
            if canScore(card) {
                // so, an array of scorepiles has an extension to update with a card? sure, it just matches the suit, then replaces the card number
                /// Finds the matching scorepile and replaces the score with the current card's; and replaces
                /// Replaces the matching scorePile's score with the card's score.
                 newScorePiles.update(with: card)
//                newScorePiles = scorePiles(updatedWith: card)
                if card.number == Setup.MaxCardNumber {
                    newClues = min(newClues + 1, Setup.MaxClues)
                }
                
                
                // TODO: WILO: think top-down, what's most readable?

            } else {
                newStrikes += 1
            }
            
            // draw card from deck and put in hand
            
            /// Removes and returns the first card of `self` if non-empty; returns `nil` otherwise.
            /// The top card of the deck.
            let topCard = newDeck.removeTopCard()!
            
            newHands[currentHandIndex].add(card)
            
            /// A mutable copy of the hands.
//            var newHands = turn.start.hands
            
            /// The matching score pile's index.
            // could be turn.start.scorePileIndex(for: card/suit?) or card.scorePileIndex
            // or returns Bool for valid/not like turnStart.allowsPlay(for: card), turnStart.canScore(card), turnStart.canPlay(card).
//            let scorePileIndex = turn.start.scorePiles.firstIndex(where: {
//                $0.suit == card.suit
//            })!
        
            
            // If the play is valid, then increase the score and check for bonus clue. Else, add a strike.
//            if card.number == (turn.start.scorePiles[scorePileIndex].score + 1) {
//                /// A mutable copy of the score piles.
//                var newScorePiles = turn.start.scorePiles
//
//                //TODO: testing; at least see how the code works if we do var newScorePile instead of (only?) var newScorePiles
//                // or, try scorePile.score
//                // or, turnStart.not update but like appending(), turnStart.updatingScore(with: card)
//                // but will that work? we want it to return a copy of turnStart with the updated score
//                turn.start.scorePiles[scorePileIndex].score = 3
//
//                newScorePiles.removeLast()
//                let testArray: [ScorePile] = turn.start.scorePiles.removeLast()
//                let testArray2: [ScorePile] = turn.start.scorePiles.mutableCopy
//
//                newScorePiles[scorePileIndex].score += 1
//
//                /// If a score pile is finished, a clue is added.
//                if card.number == 5 {
//                    clues = min(Game.MaxClues, turn.start.clues + 1)
//                } else {
//                    clues = turn.start.clues
//                }
//
//                strikes = turn.start.strikes
//                scorePiles = newScorePiles
//            } else {
//                // TODO: Put card in discard (really we just need to mark it as unavailable, same as any played card); when we add the ability to look at what could be in the deck, we'll worry about this. Current AI has x-ray.
//                clues = turn.start.clues
//                strikes = turn.start.strikes + 1
//                scorePiles = turn.start.scorePiles
//            }
//            // draw card from deck and put in hand; ok, we draw a card from the deck, but it's immutable?
//            // todo: this isn't as readable; add deck.removeTopCard?
//            turn.start.deck.cards.removeFirst()
//
//            /// A mutable copy of the deck.
//            var newDeck = turn.start.deck
//
//            /// The top card of the deck.
//            let topCard = newDeck.removeTopCard()
//
//            /// A mutable copy of the hands.
//            var newHands = turn.start.hands
        case .discard:
            // TODO: implement .discard
            clues += 1
            // draw card from deck and put in hand
            /// The top card of the deck.
            // TODO: replace with like deck.topCard, named appropriately (deck.removeFirst()?)
            let topCard = deck.cards.removeFirst()
        //            hands[index].cards.append(card) use += []
        case .clue:
            clues -= 1
        }
        return Setup(hands: newHands, currentHandIndex: newCurrentHandIndex, deck: newDeck, clues: newClues, strikes: newStrikes, scorePiles: newScorePiles)

    }
    
    /// Returns a `Bool` that reflects whether we can score by playing `card`.
    func canScore(_ card: Card) -> Bool {
        /// Returns the score that matches card's suit.
        // if scorePiles.
        if score(for: card) + 1 == card.number
        // if
        // if matchingScore(card) + 1 == card.number
        if scorePiles[scorePileIndex].score + 1 == card.number)
    }
    
     /// The updated score pile. (may need elsewhere)
    //                let scorePile = scorePile(updatedWith: card)
                   
    /// Returns a `TurnStart` that has the, er, ScorePiles?
    func updatingScore(with card: Card) -> Setup {
        
    }
}
