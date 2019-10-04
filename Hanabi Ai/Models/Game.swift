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
    // TODO: deprecate?
    // Returns a string defining a random deck.
//    static var randomDeckDescription: String {
//        var deck = Deck()
//        deck.shuffle()
//        let description = deck.description
//        return description
//    }
    
    //TODO: Update Published. I probably don't need to publish numberOfPlayers. But deck will change.
    let numberOfPlayers: Int
    let deckSetup: DeckSetup
    let customDeckDescription: String
    let startingDeck: Deck
    var deck: Deck
    @Published var turns: [Turn] = []
    
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        self.numberOfPlayers = numberOfPlayers
        self.deckSetup = deckSetup
        self.customDeckDescription = customDeckDescription
        var deck = Deck()
        switch self.deckSetup {
        case .random:
            deck.shuffle()
        // TODO: add Custom deck setup
        case .custom:
            ()
        }
        self.deck = deck
        self.startingDeck = self.deck
        dealHands()
    }
    
//    convenience init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
//        self.init()
//    }
    
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
        let turn = Turn(number: 1, hands: hands, currentHandID: hands.first!.id, deck: deck)
        self.turns.append(turn)
    }
        
    // Play each turn until the end.
    func play() {
        // Let's do a test version here. It'll add a turn.
        
        // pseudocode for play()
        // play t1
        // set up t2 from t1
        // play t2
        // repeat for awhile
        var gameIsOver: Bool = false
        print("play testing")
        var turnIndex: Int = 0
        while !gameIsOver {
            playTurn(&self.turns[turnIndex])
//            let nextTurn = makeTurnAfter(self.turns[turnIndex])
//            self.turns.append(nextTurn)
            // check for EOG; TODO: Update this condition; make func?
            if true {
                gameIsOver = true
                continue
            }
            turnIndex += 1
        }
    }
    
    /// Do an action for this turn.
    func playTurn(_ turn: inout Turn) {
        turn.action = Action(type: .clue, number: 2)
//        turn.action = Action(type: .clue, suit: .white)
//        turn.action = Action(type: .play, card: turn.hands[0].cards[2])
//        turn.action = Action(type: .discard, card: turn.hands[0].cards[1])

    }
    
    //
//    func makeTurnAfter(_ turn: Turn) -> Turn {
//        // The next turn is similar to the first, but +1 number. new handID. If clue given, one less clue. If play/discard, then hands different. And deck.
//        let number = turn.number + 1
//        let hands = turn.hands
//        // how do I get from current hand to next hand? we're passing it by ID, not by index. hmm
//        var deck = turn.deck
//        var clues = turn.clues
//        var strikes = turn.strikes
//        switch turn.action!.type {
//        case .play:
//            // if right, increase score; if 5, gain 1 clue (if not max)
//            // if wrong, put in discard, increase strikes
//            // draw card from deck and put in hand
//        case .discard:
//            clues += 1
//            // draw card from deck and put in hand
//            let card = deck.cards.removeFirst()
////            hands[index].cards.append(card)
//        case .clue:
//            clues -= 1
//        }
//        let nextTurn = Turn(number: number, hands: hands, currentHandID: hands.first!.id, deck: deck, clues: clues, strikes: strikes)
//
//    }
}
