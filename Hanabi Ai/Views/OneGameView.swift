//
//  OneGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/18/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

/// A view that shows one game played by the computer.
///
/// So the user can analyze the game first, the game doesn't start immediately.
struct OneGameView: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        /// The game. For convenience.
        let game = model.game
        
        return Form {
            Section(header: Text("Deck Setup")) {
                DeckView(deck: game.startingDeck, label: game.deckSetup.name)
                    .font(.caption)
            }
            Section(header: Text("Turn 1 Setup")) {
//                Turn1SetupGroup(setup: game.turns[0].setup, playFunction: game.play)
                Turn1SetupGroup()
            }
//            Section(header: TurnsSectionHeader()) {
//                TurnsGroup(turns: game.turns)
//            }
            Section(header: TurnsSectionHeader()) {
//                TurnsGroup(turns: game.turns)
                TurnsGroup()
            }
            // TODO: Can use EO here and below. After I get it refreshing again on turns. if kept, should update doc comments for methods.
            Section(header: Text("Results")) {
                ResultsGroup(gameIsOver: game.isOver, results: game.results)
            }
        }
        .navigationBarTitle(Text("One Game"), displayMode: .inline)
        .onAppear {
            print("OGV onAppear() called")
            self.model.makeGame()
        }
    }
}

// MARK: Section: Deck Setup

/// A view that shows a label and a deck.
///
/// The format is `label`, `": "` (which has a non-breaking space), and the deck.
struct DeckView: View {
    /// A string for labeling the deck.
    let label: String

    /// The deck.
    let deck: Deck

    /// Creates a deck view that shows the specified label and deck.
    ///
    /// Default label: `"Deck"`.
    init(deck: Deck, label: String = "Deck") {
        self.deck = deck
        self.label = label
    }

    var body: some View {
        Text("\(label): ") + deck.coloredText
    }
}

// MARK: Section: Turn 1 Setup

/// A view that shows a game's setup after hands have been dealt, and includes a "Play" button.
///
/// The game doesn't start until the user presses "Play," so they can analyze the game first.
struct Turn1SetupGroup: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    /// The game's setup after hands have been dealt.
//    let setup: Setup

    /// A function that plays a game from its turn 1 setup.
//    let playFunction: () -> Void
    
    var body: some View {
        let setup = model.game.turns[0].setup
        return Group {
            Group {
                HandsView(hands: setup.hands)
                DeckView(deck: setup.deck)
            }
            .font(.caption)
//            PlayButtonView(playFunction: playFunction)
            PlayButtonView()
        }
    }
}

/// A view that shows the specified hands.
struct HandsView: View {
    /// The hands to show.
    let hands: [Hand]
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Hands: ")
            VStack(alignment: .leading) {
                ForEach(hands.indices) {
                    self.hands[$0].coloredText
                }
            }
        }
    }
}

// TODO: trying specific function, just because. So the method isn't as generic right now.
/// A  view that shows a button that plays something.
struct PlayButtonView: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    /// A function that plays something.
//    let playFunction: () -> Void
    
    var body: some View {
        // The spacers are to center the button.
        HStack {
            Spacer()
//            Button(action: playFunction) {
            Button(action: model.game.play) {
                Text("Play")
            }
            Spacer()
        }
    }
}

// MARK: Section: Turns

/// A view that shows the header for the turns section.
///
/// TODO: Add legend to UI via popover/context button, if that's doable on iPhone
struct TurnsSectionHeader: View {
    var body: some View {
        Text("Turns")
        // For popover button
//        + Text(" (g/r/w/b/y: green/red/white/blue/yellow)")
//        + Text(" (C/S/D: Clues/Strikes/Deck)")
    }
}

/// A view that shows the specified turns.
struct TurnsGroup: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    /// The turns to show.
//    let turns: [Turn]

    var body: some View {
        let turns = model.game.turns
        return Group {
            //  TODO: Align header and rows. E.g., Turn takes 40% of row, grwby takes 40%, cs takes 20%
            //  Ugh. Alignment can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
            TurnViewHeader()
            ForEach(turns, id: \.number) {
                TurnView(turn: $0)
            }
        }
    }
}

/// A view that shows the column headers for turn views.
struct TurnViewHeader: View {
    var body: some View {
        // TODO: Align with elements of TurnView.
        HStack {
            Text("Hands")
            Suit.allLettersText
            Text("C/S/D")
            Text("Action")
        }
        .font(.caption)
    }
}

/// A view that shows the info needed to understand the specified turn.
struct TurnView: View {
    /// The turn to show.
    let turn: Turn
    
    var body: some View {
        /// The start of the turn.
        let setup = turn.setup
        
        return HStack {
            Text("\(turn.number).")
            PlayerHandsView(hands: setup.hands, currentHandIndex: setup.currentHandIndex)
            ScorePilesView(scorePiles: setup.scorePiles)
            Text("\(setup.clues)/\(setup.strikes)/\(setup.deck.count)")
            ActionView(playerIndices: setup.hands.indices, currentPlayerIndex: setup.currentHandIndex, action: turn.action)
        }
        .font(.caption)
    }
}

/// A view that shows each player's hand and highlights the current player.
struct PlayerHandsView: View {
    /// The players' hands.
    let hands: [Hand]
    
    /// The index of `hands` for the current player.
    let currentHandIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(hands.indices) {
                if $0 == self.currentHandIndex {
                    self.hands[$0].coloredText.bold()
                } else {
                    self.hands[$0].coloredText
                }
            }
        }
    }
}

/// A view that shows the scores in the specified score piles.
///
/// Scores are colored. But in case of colorblind users, use this view with a header which lists the suit order.
struct ScorePilesView: View {
    /// The score piles that contain the scores to show.
    let scorePiles: [ScorePile]
    
    var body: some View {
        /// An array of texts, where each text shows a colored score.
        let coloredScoreTexts = scorePiles.map {
            Text("\($0.score)")
                .foregroundColor($0.suit.color)
        }
        
        return coloredScoreTexts.concatenated(withSeparator: "/")
    }
}

/// A view that shows the current player's action and highlights it.
///
/// The highlight is meant to match views that highlight the current player's hand.
struct ActionView: View {
    /// A range valid for looping through all players.
    let playerIndices: Range<Int>

    /// The current player's index.
    let currentPlayerIndex: Int
    
    /// The player's action.
    let action: Action?
    
    var body: some View {
        /// A string that describes the action.
        ///
        /// If action is `nil`, value is `"??"`.
        let actionString = action?.abbr ?? "??"
        
        return VStack {
            ForEach(playerIndices) {
                if $0 == self.currentPlayerIndex {
                    Text("\(actionString)").bold()
                } else {
                    Text("\n")
                }
            }
        }
    }
}



// MARK: Section: Results

// TODO: Update doc when working on this. What do we want in the results? Number of turns, score/max, remaining deck, if any, # strikes, # clues, Kinda like an F turn
/// A view that shows the final state of the game, and a summary.
struct ResultsGroup: View {
    /// A Boolean value that indicates whether the game is over.
    let gameIsOver: Bool
    
    /// temp def
    /// hmm, not sure what type this will be yet
    let results: String
    
    var body: some View {
        Text(gameIsOver ? "Game done!" : "??")
            .font(.caption)
    }
}

// MARK: Previews

struct OneGameView_Previews: PreviewProvider {
    /// The model for this app.
    static var model = Model()

    static var previews: some View {
        NavigationView {
            // TODO: When I have other modes working, like 3+ players, will have to check if Live Preview works with that, or if code below needs to be modified.
            OneGameView().environmentObject(model)
//            OneGameView(numberOfPlayers: 2, deckSetup: .random, customDeckDescription: "")
//            OneGameView(numberOfPlayers: 2, deckSetup: .custom, customDeckDescription: "???")
        }
    }
}
