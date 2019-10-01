//
//  Game.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// FYI: Why is this a class (vs. struct)? We need to control identity. E.g., if we simulate two identical games, they're still different.
class Game: ObservableObject {
    // Returns a string defining a random deck.
    static var randomDeckDescription: String {
        var deck = Deck()
        deck.shuffle()
        let description = deck.description
        return description
    }
    
    //TODO: Update Published. I probably don't need to publish numberOfPlayers. But deck will change.
    @Published var numberOfPlayers: Int = 2
    var deckSetup: DeckSetup = .random
    var customDeckDescription: String = ""
    var startingDeckDescription: String = ""
    var deck: Deck
    var turns: [Turn] = []
    
    init() {
        var deck = Deck()
        switch self.deckSetup {
        case .random:
            deck.shuffle()
        // TODO: add Custom deck setup
        case .custom:
            ()
        }
        self.deck = deck
        self.startingDeckDescription = self.deck.description
        dealHands()
    }
    
    convenience init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        self.init()
    }
    
    // Deal starting hands. 
    func dealHands() {
        var hands: [Hand] = []
        // Get players.
        for number in 1...numberOfPlayers {
            let player = "P\(number)"
            let hand = Hand(player: player)
            hands.append(hand)
        }
        // Deal cards to each player.
        //TODO: for 4/5 players, it's 4 cards each
        let numberOfCardsPerPlayer = 5
        for _ in 1...numberOfCardsPerPlayer {
            // Using index instead of for-in, because we need the reference.
            for index in hands.indices {
                let card = deck.cards.removeFirst()
                hands[index].cards.append(card)
            }
        }
        let turn = Turn(hands: hands, deck: deck)
        self.turns.append(turn)
        print("\(deck.description)")
    }
    
    //TODO: Game makes nextTurn from previous Turn
    
}
