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
    
    //TODO: May need to update which properties are Published. Think about it.
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
    
    // Deal starting hands. 
    func dealHands() {
        
        // Assign players.
        var hands = (1...numberOfPlayers).map {
            Hand(player: "P\($0)")
        }
        
        // 2–3 players: 5 cards each; 4–5 players: 4 cards.
        let numberOfCardsPerPlayer = [2, 3].contains(numberOfPlayers) ? 5 : 4
        
        (1...numberOfCardsPerPlayer).forEach { _ in
            // Deal each player a card.
            // Using `indices` instead of looping over `hands`, because we need the reference.
            hands.indices.forEach {
                let topCard = deck.cards.removeFirst()
                hands[$0].cards.append(topCard)
            }
        }
        
        let turn = Turn(number: 1, hands: hands, currentHandIndex: 0, deck: deck)
        self.turns.append(turn)
    }
        
    // Play each turn until the game ends.
    func play() {
        // Let's do a test version here. It'll add a turn.
        
        // pseudocode for play()
        // play t1
        // set up t2 from t1
        // play t2
        // repeat for awhile
        var gameIsGoing: Bool = true
//        var gameIsOver: Bool = false
        print("play testing")
        while gameIsGoing {
            // Play current turn.
            var currentTurn = self.turns.last!
            currentTurn.action = actionForTurn(currentTurn)
            let lastIndex = self.turns.count - 1
            self.turns[lastIndex] = currentTurn
            
            // If game still going, add next turn.
            let nextTurn = makeTurnAfter(currentTurn)
            gameIsGoing = !self.isOver(turn: nextTurn)
            if gameIsGoing {
                self.turns.append(nextTurn)
                // TODO: temp to avoid infinite loop
                break
            } else {
                // TODO: If game is over, don't add next turn, but add it to Results?
                print("game is over!")
                ()
            }
        }
    }
    
    /// Return the action for this turn.
    func actionForTurn(_ turn: Turn) -> Action {
        // TODO: go beyond testing
        let action: Action = Action(type: .clue, number: 2)
        return action
//            turn.action = Action(type: .clue, number: 2)
    //        turn.action = Action(type: .clue, suit: .white)
    //        turn.action = Action(type: .play, card: turn.hands[0].cards[2])
    //        turn.action = Action(type: .discard, card: turn.hands[0].cards[1])
        }
//    func playTurn(_ turn: inout Turn) {
//        turn.action = Action(type: .clue, number: 2)
////        turn.action = Action(type: .clue, suit: .white)
////        turn.action = Action(type: .play, card: turn.hands[0].cards[2])
////        turn.action = Action(type: .discard, card: turn.hands[0].cards[1])
//
//    }
    
    //
    func makeTurnAfter(_ turn: Turn) -> Turn {
        // The next turn is similar to the first, but +1 number. new handID. If clue given, one less clue. If play/discard, then hands different. And deck.
        let number = turn.number + 1
        let hands = turn.hands
        // how do I get from current hand to next hand? we're passing it by ID, not by index. hmm
        var deck = turn.deck
        var clues = turn.clues
        var strikes = turn.strikes
        switch turn.action!.type {
        case .play:
            // TODO: if right, increase score; if 5, gain 1 clue (if not max)
            // if wrong, put in discard, increase strikes
            // draw card from deck and put in hand
            ()
        case .discard:
            // TODO: implement .discard
            clues += 1
            // draw card from deck and put in hand
            let card = deck.cards.removeFirst()
//            hands[index].cards.append(card)
        case .clue:
            clues -= 1
        }
        // TODO: properly code next hand index
        let nextTurn = Turn(number: number, hands: hands, currentHandIndex: 1, deck: deck, clues: clues, strikes: strikes)
        return nextTurn
    }
    
    /// Whether this game is over. There are 3 ways: Perfect score, 3rd strike, or turns run out. In the last case, after the last card is drawn, each player gets one turn.
    func isOver(turn: Turn) -> Bool {
        // TODO: So we need the score, the strikes, the deck
        let tempBool: Bool
        // switch statement?
        if (turn.strikes == 3) {
            tempBool = true
            // TODO: perfect score. each score has to be 5.
//        } else if (scoresArePerfect(turn.scores)) {
//            turn.scores.forEach { score in
//                print("hi")
//            }
//            tempBool = true
//
//             // TODO: turns run out.
//        } else if (turn.strikes == 3) {
//            ()
        } else {
            tempBool = false
        }
        return tempBool
    }
    
//    func scoresArePerfect(scores: [Suit: Int]) -> Bool {
//
//    }
}
