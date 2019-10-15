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
    
    /// The max number of clues you can have at any time.
    static let MaxClues = 8
    
    /// The number of strikes.
    let strikes: Int
    
    /// The face-up piles for scoring each suit, in suit order.
    let scorePiles: [ScorePile]
    
    /// An array of all score piles, in suit order, with each score set to 0.
    private static let InitialScorePiles = Suit.allCases.sorted().map {
        ScorePile(suit: $0, score: 0)
    }
    
    /// Creates a setup with the specified parameters.
    init(hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int = 8, strikes: Int = 0, scorePiles: [ScorePile] = InitialScorePiles) {
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        self.clues = clues
        self.strikes = strikes
        self.scorePiles = scorePiles
    }
    
    /// Chooses and returns an action for this setup.
    /// Under construction. The chosen action will depend on the setup and the AIs.
    func chooseAction() -> Action {
        //testing
        let action: Action
        
        // For testing: always choose a clue (may not even be a valid clue)
//        action = Action(type: .clue, card: nil, number: 2, suit: nil)

        // temp; play first card in hand, for testing
        action = Action(type: .play, card: hands[currentHandIndex].first!, number: nil, suit: nil)
        
        return action
    }
    
    /// Returns a Boolean value that indicates whether this setup has reached game over.
    func isGameOver() -> Bool {
        
    }
}
