//
//  OneGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/18/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

// TODO: Hmm, apple's own swift docs don't use much highlighting, at least in the summary. Also, the parameters have multiple-sentence summaries. The summaries are still general.
// so, naming conventions are consistent, or at least I understand. The summary conventions are not.
// popFirst() in actual docs is different than guidelines.
// Docs seem consistent with SwiftUI docs, which came later. What we really want is something from Xcode 10. removeAll() and toggle() work
// But what about hand.remove(card)? and turns.remove(turn)?
// sig would be Hand.remove(_ Card), [Turn].remove(_ Turn)
// more natural than Array.remove(_ Element), but the former has way more code
// like you could have
//Board.remove(_ piece: Piece) and
//Hand.remove(_ card: Card) and/or
//Array.remove(_ element: Element)
// and Board and Hand could call Array.remove(). What you gain is the same use signature, but better doc summary. Or at least different. Well, it would make someone wonder, why not just use Array.remove? How's this different? So I guess if the implementation is that straightfoward, you should skip it.
// Removes the specified element from the array.
// Removes the specified piece from the board.
// Removes the specified card from the hand.

/// A view that shows one game played by the computer.
///
/// So the user can analyze the game first, the game doesn't start immediately.
struct OneGameView: View {
    /// The `Game` to play.
    @ObservedObject var game: Game

    /// Creates a `OneGameView` with one `Game` by using `numberOfPlayers`, `deckSetup`, and `customDeckDescription`.
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String) {
        //testing
        //testing
        var bob = [0...3]
        bob.remove(at:0)
        
        self.game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
    }
    
    var body: some View {
        Form {
            /// A `Section` that shows the deck used in a game.

            DeckSetupSection(deckSetup: game.deckSetup, startingDeck: game.startingDeck)
            // TODO: pass in turnStart? gameState? what's here? the starting setup, so that can't change as the game model updates
            // StartingSetupSection(startingGameState: game.startingState)
            // StartingSetupSection(firstTurnState: game.turns[0].turnStart)
            // StartingSetupSection(firstTurnStart: )
            // (startOfFirstTurn: ??) (firstTurnSetup: ?)
            // (startingState: game.startingState)
            // (game.turns[0].state)
            // no view should need to know subproperties, only properties?
            // StartingSetupSection(startingState: game.turns[0].turnStart)
            // find the balance between reusability and readability; read multiple times
            
            /// A `Section` that shows a game's state after hands have been dealt, and includes a "Play" button.
            StartingSetupSection(startingState: game.startingState, playFunction: game.play)

            /// A `Section` that shows a `Game`'s state after hands have been dealt.
//            StartingSetupSection(game: game)
            
            TurnsSection(turns: game.turns)
            ResultsSection(gameIsOver: game.isOver, results: game.results)
        }
        .navigationBarTitle(Text("One Game"), displayMode: .inline)
    }
}

// MARK: DeckSetupSection

/// A `Section` that shows the deck used in a game.
struct DeckSetupSection: View {
    /// The `DeckSetup` used.
    let deckSetup: DeckSetup
    
    /// The `Deck` before any cards are dealt.
    let startingDeck: Deck
    
    var body: some View {
        Section(header: Text("Deck Setup")) {
            DeckView(deck: startingDeck, label: deckSetup.name)
                .font(.caption)
        }
    }
}

/// A `View` that shows `deck`, with `label` in front.
///
/// After `label` is ": ", which has a non-breaking space.
struct DeckView: View {
    /// A `Deck`.
    let deck: Deck
    
    /// A `String` that shows in front of `deck`.
    let label: String
    
    /// Creates a `DeckView` with a `deck` and a `label`.
    init(deck: Deck, label: String = "Deck") {
        self.deck = deck
        self.label = label
    }
    
    var body: some View {
        // Non-breaking space.
        Text("\(label): ") + deck.coloredText
    }
}

// MARK: StartingSetupSection


/// A `Section` that shows a game's state after hands have been dealt, and includes a "Play" button.
///
/// By allowing the user to press "Play," they can analyze the game before the computer tries it.
struct StartingSetupSection: View {
    /// A game's starting state.
    let startingState: StartingState
    
    /// A function that plays a game from its starting state.
    let playFunction: () -> Void
    
    var body: some View {
        /// The start of the first turn.
        let firstTurnStart = game.turns.first!.start
        
        return Section(header: Text("Starting Setup")) {
            Group {
                HandsView(hands: firstTurnStart.hands)
                DeckView(deck: firstTurnStart.deck)
            }
            .font(.caption)
            PlayButtonView(playFunction: playFunction)
        }
    }
}

/// A `Section` that shows a `Game`'s state after hands have been dealt.
///
/// Includes the "Play" button. This gives the user a chance to analyze the game before the computer tries it.
//struct StartingSetupSection: View {
//    /// The `Game` to play.
//    let game: Game
//
//    var body: some View {
//        /// The start of the first turn.
//        let firstTurnStart = game.turns.first!.start
//
//        return Section(header: Text("Starting Setup")) {
//            Group {
//                HandsView(hands: firstTurnStart.hands)
//                DeckView(deck: firstTurnStart.deck)
//            }
//            .font(.caption)
//            // TODO: pass in the action/func, then I don't need to pass game.
//            PlayButtonView(game: game)
//        }
//    }
//}

/// A `View` that shows `hands`.
struct HandsView: View {
    /// An `Array` of `Hand`s.
    let hands: [Hand]
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Hands: ")
            VStack(alignment: .leading) {
                ForEach(hands.indices) {
                    // TODO: use hands[$0].coloredText
                    self.hands[$0].cards.coloredText
                }
            }
        }
    }
}

/// A  `View` that shows a button that plays a game from its starting state.
struct PlayButtonView: View {
    /// A function that plays a game from its starting state.
    let playFunction: () -> Void
    
    var body: some View {
        // The `Spacer`s are to center the `Button`.
        HStack {
            Spacer()
            Button(action: playFunction) {
                Text("Play")
            }
            Spacer()
        }
    }
}

// MARK: TurnsSection

/// A `Section` that shows the given `turns`.
struct TurnsSection: View {
    /// An `Array` of `Turn`s.
    let turns: [Turn]

    var body: some View {
        Section(header: TurnsSectionHeader()) {
            
            //  TODO: Align header and rows. E.g., Turn takes 40% of row, grwby takes 40%, cs takes 20%
            //  Ugh. Alignment can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
            TurnViewHeader()
            ForEach(turns, id: \.number) {
                TurnView(turn: $0)
            }
        }
    }
}

/// A `View` that is the header for `TurnsSection`.
///
/// TODO: Add legend to UI via popover/context button, if that's doable on iPhone
/// The text for the section header.
struct TurnsSectionHeader: View {
    var body: some View {
        Text("Turns")
        // For popover button
//        + Text(" (g/r/w/b/y: green/red/white/blue/yellow)")
//        + Text(" (C/S/D: Clues/Strikes/Deck)")
    }
}

/// A `View` that shows column headers for `TurnView`.
///
/// TODO: Align with elements of TurnView.
struct TurnViewHeader: View {
    var body: some View {
        HStack {
            Text("Hands")
            ScoreHeaderView()
            Text("C/S/D")
            Text("Action")
        }
        .font(.caption)
    }
}

/// A `View` that shows the colored text for each suit, in order. Suits are separated for legibility.
struct ScoreHeaderView: View {
    var body: some View {
        /// An `Array` of `Text`s, where each `Text` shows a `Suit`'s colored text.
        let suitTexts = Suit.allCases.sorted().map {
            $0.coloredText
        }
        
        return suitTexts.concatenated(withSeparator: "/")
    }
}

/// A `View` that shows the info needed to understand the given `turn`.
struct TurnView: View {
    /// The `Turn`.
    let turn: Turn
    
    var body: some View {
        /// The start of the turn.
        let turnStart = turn.start
        
        return HStack {
            TurnNumberView(number: turn.number)
            PlayerHandsView(hands: turnStart.hands, currentHandIndex: turnStart.currentHandIndex)
            ScorePilesView(scorePiles: turnStart.scorePiles)
            TokenPilesView(clues: turnStart.clues, strikes: turnStart.strikes, cardsInDeck: turnStart.deck.cards.count)
            ActionView(numberOfPlayers: turnStart.hands.count, currentHandIndex: turnStart.currentHandIndex, action: turn.action)
        }
        .font(.caption)
    }
}

/// A `View` that shows which turn it is.
struct TurnNumberView: View {
    /// The turn number.
    let number: Int
    
    var body: some View {
        Text("\(number).")
    }
}

/// A `View` that shows each player's cards and highlights the current player.
struct PlayerHandsView: View {
    /// The players' cards.
    let hands: [Hand]
    
    /// The index of `hands` for the current player.
    let currentHandIndex: Int
    
    var body: some View {
        /// A `Range` for looping over `hands`, because `Hand` isn't `Identifiable`.
        let handsIndices = hands.indices
        
        /// An `Array` of `Text`s, where each shows a hand, with color.
        let coloredTexts = handsIndices.map {
            // TODO: use hands[$0].coloredText
            hands[$0].cards.coloredText
        }
        
        return VStack(alignment: .leading) {
            ForEach(handsIndices) {
                if $0 == self.currentHandIndex {
                    coloredTexts[$0].bold()
                } else {
                    coloredTexts[$0]
                }
            }
        }
    }
}

/// A `View` that shows the scores in the given `scorePiles`. Scores are separated for legibility and colored appropriately.
///
/// Colorblind users may not know which score is for which suit. So, `ScorePilesView` should be used with `ScoreHeaderView`, which lists the suit order.
struct ScorePilesView: View {
    /// The `ScorePile`s that contain the scores to show.
    let scorePiles: [ScorePile]
    
    var body: some View {
        /// An `Array` of `Text`s, where each `Text` shows a score, with color.
        // TODO: extend ScorePile to have scorepile.coloredScore? scorePile.coloredText? coloredScoreText?
        let scoreTexts = scorePiles.map {
            Text("\($0.score)")
                .foregroundColor($0.suit.color)
        }
        
        return scoreTexts.concatenated(withSeparator: "/")
    }
}

/// A `View` that shows the number of clues and strikes, and the number of cards remaining in the deck.
struct TokenPilesView: View {
    /// The number of clues.
    let clues: Int
    
    /// The number of strikes.
    let strikes: Int
    
    /// The number of cards remaining in the deck.
    let cardsInDeck: Int
    
    var body: some View {
        Text("\(clues)/\(strikes)/\(cardsInDeck)")
    }
}

/// A `View` that shows the current player's action and highlights it.
///
/// The action is highlighted to match `PlayerHandsView`.
struct ActionView: View {
    /// The number of players.
    let numberOfPlayers: Int
    
    /// The current player's index, assuming an `Array` of the players.
    let currentHandIndex: Int
    
    /// The player's action (if none yet, then `nil`).
    let action: Action?
    
    var body: some View {
        /// A `String` describing the action.
        ///
        /// If action is `nil`, value is `"??"`.
        let actionString = action?.abbr ?? "??"
        
        return VStack {
            ForEach(0..<numberOfPlayers) {
                if $0 == self.currentHandIndex {
                    Text("\(actionString)").bold()
                } else {
                    Text("\n")
                }
            }
        }
    }
}

// MARK: ResultsSection

/// A `Section` that shows the final state of the game, and a summary.
// TODO: Update doc when working on this. What do we want in the results? Number of turns, score/max, remaining deck, if any, # strikes, # clues, Kinda like an F turn
struct ResultsSection: View {
    /// A `Bool` that reflects whether the game is over.
    let gameIsOver: Bool
    
    /// temp def
    /// hmm, not sure what type this will be yet
    let results: String
    
    var body: some View {
        Section(header: Text("Results")) {
            Text(gameIsOver ? "Game done!" : "??")
                .font(.caption)
        }
    }
}

// MARK: Previews

struct OneGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // TODO: When I have other modes working, like 3+ players, will have to check if Live Preview works with that, or if code below needs to be modified.
            OneGameView(numberOfPlayers: 2, deckSetup: .random, customDeckDescription: "")
        }
    }
}

