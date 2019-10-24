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
    
    /// The number of turns left, if the deck is empty.
    let turnsLeft: Int
    
    /// An array of all score piles, in suit order, with each score set to 0.
    static let InitialScorePiles = Suit.allCases.sorted().map { ScorePile(suit: $0, score: 0) }
    
    /// Creates a setup with the specified parameters.
    init(hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int, strikes: Int, scorePiles: [ScorePile], turnsLeft: Int) {
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        self.clues = clues
        self.strikes = strikes
        self.scorePiles = scorePiles
        self.turnsLeft = turnsLeft
    }
    
    // MARK: Actions
    
    /// Returns the first playable card in the specified hand; if none, `nil`.
    func firstPlayableCard(in hand: Hand) -> Card? {
        hand.first(where: {scorePiles.nextIs($0)})
    }
    
    /// Returns the first scored card in the specified hand; if none, `nil`.
    func firstScoredCard(in hand: Hand) -> Card? {
        hand.first(where: {scorePiles.alreadyHave($0)})
    }
    
    /// Returns the first card in the specified hand that appears again in any hand (including itself); if none, `nil`.
    func firstHandDuplicateCard(in hand: Hand) -> Card? {
        hand.first(where: {hands.count(for: $0) > 1})
    }
    
    /// Returns the cards in the specified hand that appear again in the deck.
    func deckDuplicates(in hand: Hand) -> Array<Card> {
        hand.filter{deck.contains($0)}
    }
    
    /// Returns the cards in the specified hand that are now unique.
    ///
    /// I.e., if discarded, a perfect score is impossible.
    func singletons(in hand: Hand) -> Array<Card> {
        // Return cards that are only found once in all hands, and are not in the deck.
        hand.filter{hands.count(for: $0) == 1}
            .filter{!deck.contains($0)}
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand is a duplicate.
    ///
    /// A duplicate can be in the deck, in another hand, or in even the same hand.
    func duplicatesAre(in hand: Hand) -> Bool {
        deckDuplicatesAre(in: hand) || handDuplicatesAre(in: hand)
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand is a deck duplicate.
    func deckDuplicatesAre(in hand: Hand) -> Bool {
        hand.contains{deck.contains($0)}
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand is a hand duplicate.
    ///
    /// A hand duplicate can be in any hand, including itself.
    func handDuplicatesAre(in hand: Hand) -> Bool {
        hand.contains{hands.count(for: $0) > 1}
    }
    
    /// Returns a Boolean value that indicates whether the other players have only singletons.
    func othersHaveOnlySingletons() -> Bool {
        for (index, hand) in hands.enumerated() {
            guard index != currentHandIndex else {
                continue
            }
            if duplicatesAre(in: hand) {
                return false
            }
        }
        return true
    }
    
    /// Returns the card that will take the most turns to play.
    ///
    /// Looks at the deck and assumes optimal play. If none playable, returns `nil`.
    ///
    /// To estimate how slow a card is, we look at the cards that have to score first, and which of those is deepest in the deck.
    // TODO: Right now there are some approximations made. We don't count explicitly who has which cards or the order they're drawn. It's mostly a function of how deeply cards are buried in the deck.
    func slowestPlayableCard(cards: Array<Card>) -> Card? {
        /// The slowest playable card.
        var slowestCard: Card?
        
        /// The number of turns to play the slowest card.
        var turnsToPlaySlowestCard = 0
        
        for card in cards {
            /// The matching score pile.
            let scorePile = scorePiles.first{$0.suit == card.suit}!
            
            // If unplayable, skip.
            guard card.number > scorePile.number else {
                continue
            }
            
            /// The number of turns to play this card.
            var turnsToPlay = 0
            
            /// The number of cards to draw to be able to play this card.
            var turnsToDraw = 0
            
            /// The card that has to score before this card.
            var beforeCard = Card(suit: card.suit, number: card.number - 1)
            
            while beforeCard.number > scorePile.number {
                // 1 turn to play the "before" card.
                turnsToPlay += 1
                
                // We'll worry only about cards not in a hand.
                if !hands.contain(beforeCard), let index = deck.firstIndex(of: beforeCard) {
                    
                    // One "before" card will be deepest. Once we have that, we'll have the others.
                    turnsToDraw = max(turnsToDraw, index + 1)
                }
                beforeCard = Card(suit: card.suit, number: beforeCard.number - 1)
            }
            turnsToPlay += turnsToDraw
            
            if turnsToPlay > turnsToPlaySlowestCard {
                slowestCard = card
                turnsToPlaySlowestCard = turnsToPlay
            }
        }
    
        return slowestCard
    }

    /// Chooses and returns an action for this setup.
    /// todo: Under construction. The chosen action will depend on the setup and the AIs.
//    func chooseAction() -> Action {
//        //testing
//        let action: Action
//        
//
//        // temp; play first card in hand, for testing
//        action = Action(type: .play, card: hands[currentHandIndex].first!, number: nil, suit: nil)
//        
//        return action
//    }
    
    // MARK: Game end
    
    /// Returns a Boolean value that indicates whether this setup has reached the end of the game.
    ///
    /// There are three ways for Hanabi to end: A 3rd strike, a perfect score of 25, or turns run out.
    func isGameOver() -> Bool {
        strikes == 3 || scoreIsPerfect() || outOfTurns()
    }
    
    /// Returns a Boolean value that indicates whether the score is maxed out in all score piles.
    func scoreIsPerfect() -> Bool {
        for scorePile in scorePiles {
            if scorePile.score < ScorePile.MaxNumber {
                return false
            }
        }
        return true
    }
    
    /// Returns a Booelan value that indicates whether there are no more turns left.
    ///
    /// When the last card has been drawn, each player gets one more turn, then the game ends.
    func outOfTurns() -> Bool {
        deck.isEmpty && (turnsLeft == 0)
    }
}
