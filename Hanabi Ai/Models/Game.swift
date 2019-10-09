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
/// This is a class (vs. struct), because we need to control identity. E.g., if we simulate two identical games, they're still different.
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
    
    /// A human-readable description of the starting deck, used if `deckSetup` is `custom`.
    let customDeckDescription: String
    
    /// The deck before any cards are dealt.
    let startingDeck: Deck
    
    // TODO: This may not be needed, nor right. The next turn is made from the previous turn's deck, not this. So this probably isn't updated correctly. And if we copy the startingDeck to deal hands, then we don't need this property anymore.
    /// The current deck, which players draw from throughout the game.
    var deck: Deck
    
    /// Each `Turn` in the game.
    @Published var turns: [Turn] = []
    
    /// A Bool that reflects whether this game is over.
    @Published var isOver: Bool = false
    
    /// Creates a `Game` with the given number of players and deck setup.
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        self.numberOfPlayers = numberOfPlayers
        self.deckSetup = deckSetup
        self.customDeckDescription = customDeckDescription
        
        /// The deck for the game.
        var deck: Deck
        
        switch self.deckSetup {
        case .random:
            deck = Deck()
            deck.shuffle()
        // TODO: add Custom deck setup. Read in custom deck description.
        case .custom:
            // Deck(custom: ???)
            deck = Deck()
        }
        self.deck = deck
        self.startingDeck = self.deck
        dealHands()
    }
    
    // MARK: Setup
    
    /// Deals starting hands.
    func dealHands() {
        /// An empty hand for each player.
        var hands = Array(repeating: Hand(), count: numberOfPlayers)
        
        /// The number of starting cards per player.
        ///
        /// 2–3 players: 5 each; 4–5 players: 4.
        let numberOfCardsPerPlayer = [2, 3].contains(numberOfPlayers) ? 5 : 4
        
        (1...numberOfCardsPerPlayer).forEach { _ in
            // Deal each player a card.
            // Using `indices` instead of looping over `hands`, because we need the reference.
            hands.indices.forEach {
                /// The top card of the deck.
                let topCard = deck.cards.removeFirst()
                
                hands[$0].cards.append(topCard)
            }
        }
        
        /// The first turn.
        let firstTurn = Turn(number: 1, hands: hands, currentHandIndex: 0, deck: deck)
        
        turns.append(firstTurn)
    }
    
    // MARK: Play
        
    /// Plays turns until the game ends.
    func play() {
        // Let's do a test version here. It'll add a turn.
        
        // pseudocode for play()
        // play t1
        // set up t2 from t1
        // play t2
        // repeat for awhile
        
        /// A Bool that reflects whether the game still has turns to play.
        var gameIsGoing: Bool = true

        while gameIsGoing {
            
            /// The current turn, awaiting the player's action.
            var currentTurn = turns.last!
            
            currentTurn.action = actionForTurn(currentTurn)
            
            /// The index for the current turn.
            let lastIndex = turns.count - 1
            
            turns[lastIndex] = currentTurn
            
            /// The next turn, , awaiting the player's action.
            let nextTurn = makeTurnAfter(currentTurn)
            
            gameIsGoing = !isOver(nextTurn: nextTurn)
            if gameIsGoing {
                turns.append(nextTurn)
                // TODO: temp to avoid infinite loop
                break
            } else {
                // TODO: If game is over, don't add next turn, but add it to Results?
                print("game is over!")
                ()
            }
        }
    }
    
    /// Returns an `Action` for the given `turn`.
    ///
    /// Under construction. The chosen action will depend on the game state and the AIs.
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
    
    /// Returns the `Turn` after the given `turn`.
    ///
    /// Assumes the given `turn`'s action is done.
    func makeTurnAfter(_ turn: Turn) -> Turn {
        // TODO: The next turn is similar to the first.  If play/discard, then hands different. And deck.
        /// The players' cards, which are unchanged from the end of the previous turn.
        let hands = turn.hands
                
        /// The `Array` index for the previous "current" player.
        let oldHandIndex = turn.currentHandIndex
        
        /// The `Array` index for the new current player (simple rotation).
        let currentHandIndex = (oldHandIndex == hands.count - 1) ? 0 : (oldHandIndex + 1)

        /// The remaining deck.
        var deck = turn.deck
        
        /// The number of clues.
        var clues = turn.clues
        
        /// The number of strikes.
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
            /// The top card of the deck.
            let topCard = deck.cards.removeFirst()
//            hands[index].cards.append(card)
        case .clue:
            clues -= 1
        }
        return Turn(number: turn.number + 1, hands: hands, currentHandIndex: currentHandIndex, deck: deck, clues: clues, strikes: strikes)
    }
    
    // MARK: Game end
    
    /// Returns a `Bool` that reflects whether the game is over, based on the latest `Turn`.
    ///
    /// There are three ways for Hanabi to end: A 3rd strike, a perfect score of 25, or turns run out. The last case is when the last card has been drawn, and each player has had one more turn.
    ///
    /// The latest `Turn` is the `Turn` about to played next; i.e., after the previous `Turn`'s action has been resolved.
    func isOver(nextTurn: Turn) -> Bool {
        // TODO: So we need the score, the strikes, the deck
        
        // hmm, this is kinda like multiple returns... we're saying instead of multiple assignments, we'll have one final assignment via switch. the counter argu is that if we have the info to make an assignment, we should make it and exit. esp for small functions.
        // the pro-single-staement argu for readability is you don't have to worry about assignmet in the middle of the function. let's go for short.
       
        if (nextTurn.strikes == 3) {
            return true
            // TODO: perfect score. each score has to be 5.
//        } else if (scoresArePerfect(nextTurn.scores)) {
            // map?
//            turn.scores.forEach { score in
//                print("hi")
//            }
//            tempBool = true
//
//             // TODO: turns run out.
//        } else if (outOfTurns) {
//            ()
        } else {
            return false
        }
    }
    
//    func scoresArePerfect(scores: [Suit: Int]) -> Bool {
//
//    }
}
