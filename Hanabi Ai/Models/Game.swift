//
//  Game.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A game of Hanabi, played by the computer against itself.
///
/// This is a class (vs. struct), because we want to use `ObservableObject`?
class Game: ObservableObject {
    // TODO: deprecate?
    // Returns a string defining a random deck.
//    static var randomDeckDescription: String {
//        var deck = Deck()
//        deck.shuffle()
//        let description = deck.description
//        return description
//    }
    
    //TODO: May need to update which properties are Published. Think about it.
    
    /// The number of players.
    let numberOfPlayers: Int

    /// The method of arranging the deck; e.g., randomly, or with a specific order.
    let deckSetup: DeckSetup
    
    /// A human-readable description of the starting deck, used if the deck setup is "custom".
    let customDeckDescription: String
    
    /// The deck before any cards are dealt.
    let startingDeck: Deck
    
    /// Each turn in the game.
    @Published var turns: [Turn] = []
    
    /// A Boolean value that indicates whether this game is over.
    @Published var isOver = false
    
    /// TODO: Not sure what type this will be. It's everything needed to report the results. Like, the next turnStart, plus maybe more. probably want this @Published.
    let results = "testing"
    
    /// Creates a game with the specified number of players and deck setup.
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        self.numberOfPlayers = numberOfPlayers
        self.deckSetup = deckSetup
        self.customDeckDescription = customDeckDescription
        
        /// The deck for the game.
        var deck: Deck
        
        switch self.deckSetup {
        case .random:
            deck = Game.makeRandomDeck()
            deck.shuffle()
        // TODO: add Custom deck setup. Read in custom deck description.
        case .custom:
            // Deck(custom: ???)
            deck = Deck()
        }
        self.startingDeck = deck
        dealHands()
    }
    
    // MARK: Setup
    
    /// Returns a random deck.
    static func makeRandomDeck() -> Deck {
        /// An array of 1s, as many as in a Hanabi suit.
        let suitOnes = Array(repeating: 1, count: 3)
        
        /// An array of 2s, as many as in a Hanabi suit.
        let suitTwos = Array(repeating: 2, count: 2)
        
        /// An array of 3s, as many as in a Hanabi suit.
        let suitThrees = Array(repeating: 3, count: 2)
        
        /// An array of 4s, as many as in a Hanabi suit.
        let suitFours = Array(repeating: 4, count: 2)
        
        /// An array of 5s, as many as in a Hanabi suit.
        let suitFives = Array(repeating: 5, count: 1)
        
        /// An array of 1s thru 5s, as many as in a Hanabi suit.
        let suitNumbers = suitOnes + suitTwos + suitThrees + suitFours + suitFives
        
        /// An array of all cards in a deck.
        ///
        /// How: For each suit, make its cards. Then flatten.
        var deck = Suit.allCases.flatMap { suit in
            suitNumbers.map {
                Card(suit: suit, number: $0)
            }
        }
        
        deck.shuffle()
        return deck
    }
    
    /// Deals starting hands.
    func dealHands() {
        /// An empty hand for each player.
        var hands = Array(repeating: Hand(), count: numberOfPlayers)
        
        /// The number of starting cards per player.
        ///
        /// 2–3 players: 5 each; 4–5 players: 4.
        let numberOfCardsPerPlayer = [2, 3].contains(numberOfPlayers) ? 5 : 4
        
        /// A mutable copy of the starting deck.
        var deck = startingDeck
        
        (1...numberOfCardsPerPlayer).forEach { _ in
            // Deal each player a card.
            // Using indices, because we need a reference to modify the hand.
            hands.indices.forEach {
                /// The top card of the deck.
                let topCard = deck.removeFirst()
                
                hands[$0] += [topCard]
            }
        }
        
        /// The setup for the first turn.
        let setup = Setup(hands: hands, currentHandIndex: 0, deck: deck, clues: Setup.MaxClues, strikes: 0, scorePiles: Setup.InitialScorePiles, turnsLeft: numberOfPlayers)
        
        /// The first turn.
        let turn1 = Turn(number: 1, setup: setup)

        turns += [turn1]
    }
    
    // MARK: Play
        
    /// Plays turns until the game ends.
    func play() {
        while !isOver {
            /// The current turn, awaiting the player's action.
            var currentTurn = turns.last!
            
            currentTurn.action = currentTurn.setup.chooseAction()
            
            /// The next turn's setup.
            let nextSetup = currentTurn.doAction()
            
            if nextSetup.isGameOver() {
                isOver = true
                // TODO: at game end, populate results. e.g., self.results = X
            } else {
                /// The next turn.
                let nextTurn = Turn(number: turns.last!.number + 1, setup: nextSetup)
                
                turns += [nextTurn]
            }
        }
    }
}
