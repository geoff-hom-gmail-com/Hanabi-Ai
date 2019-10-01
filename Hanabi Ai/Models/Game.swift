//
//  Game.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// Why is this a class (vs. struct)? We need to control identity. E.g., if we simulate two identical games, they're still different.
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
        dealHands()
    }
    
    convenience init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        self.init()
    }
    
    // Deal starting hands. 
    func dealHands() {
        // So how do we know the player names? That's part of auto-play. But We'd probably use numbers, as it's shorter.
        // can use a for, or another thing like map? We've got Int = 2
//        var players: [String] = []
        var hands: [Hand] = []
        for number in 1...numberOfPlayers {
            // we want to name the player
            // and get each X card from the top
            // as it's random, we could just pull the first X cards, but later when we have games for real life, it'll be buggy.long way is short way.
            // or we could here just get the player names, and do the rest below
            let player = "P\(number)"
            let hand = Hand(player: player)
//            players.append(player)
            hands.append(hand)
        }
        //TODO: for 4/5 players, it's 4 cards each
        let numberOfCardsPerPlayer = 5
        for _ in 1...numberOfCardsPerPlayer {
            //TODO: get card from top of deck; give it to next player
            for var hand in hands {
                // TODO: Hmm, cards isn't really a string. It should have a string rep, but it's really individual cards. So [String] or [Card]
                //TODO: How do we draw a card from the deck?
                let card = deck.cards.removeFirst()
                hand.cards.append(card)
            }
        }
//        let hand1 = Hand(player: "P1", cards: "r1w3")
//        let hand2 = Hand(player: "P2", cards: "g2w2")
        let turn = Turn(hands: hands)
        self.turns.append(turn)
    }
    
    //TODO: Game makes nextTurn from previous Turn
    
}
