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
                Turn1SetupGroup()
            }
            Section(header: TurnsSectionHeader()) {
                TurnsGroup()
            }
            Section(header: Text("Results")) {
                ResultsGroup()
            }
        }
        .navigationBarTitle(Text("One Game"), displayMode: .inline)
        .onAppear {
            self.model.makeGame()
            
            /// If we want to test a deck again, we need to be in Debug Preview and check the console for this. (Temp workaround until we get text selection working for text views in SwiftUI.)
            print("Deck: \(self.model.game.startingDeck.description)")
        }
        .onDisappear {
            // We shouldn't need this, but the app would crash when playing a game, going back, then trying to play a new game. Creating an unplayed game, below, fixed it.
            self.model.game = Game()
        }
    }
}

// MARK: Section: Turn 1 Setup

/// A view that shows a game's setup after hands have been dealt, and includes a "Play" button.
///
/// The game doesn't start until the user presses "Play," so they can analyze the game first.
struct Turn1SetupGroup: View {
    /// The model for this app.
    @EnvironmentObject var model: Model

    var body: some View {
        /// The game. For convenience.
        let game = model.game
        
        /// The game's setup after hands have been dealt.
        let setup = game.turns[0].setup
        
        return Group {
            Group {
                HandsView(hands: setup.hands)
                DeckView(deck: setup.deck)
            }
            .font(.caption)
            
            // TODO: When Xcode 11.2 is out, see if Picker works better. (See AIPicker.swift.)
//            AIPicker(index: $game.aiIndex)
            AIView()
            
            PlayButtonView(playFunction: game.play)
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

/// A view that shows the AI for the game.
/// TODO: this is temp, until we can get AI-picking working on a game/turn basis. Wait for Xcode 11.2?
struct AIView: View {
    /// The model for this app.
    @EnvironmentObject var model: Model

    var body: some View {
        Text("AI: \(Model.AIs[model.game.aiIndex].name)")
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

/// A view that shows a game's turns.
struct TurnsGroup: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        Group {
            //  TODO: Align header and rows. E.g., Turn takes 40% of row, grwby takes 40%, cs takes 20%
            //  Ugh. Alignment can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
            TurnViewHeader()
            ForEach(model.game.turns, id: \.number) {
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

/// A view that shows the final setup of the game, and a summary.
struct ResultsGroup: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        /// The game. For convenience.
        let game = model.game
        
        return Group {
            if game.isOver {
                ScorePilesView(scorePiles: game.endSetup!.scorePiles)
            } else {
                Text("??")
            }
        }
        .font(.caption)
    }
}
// TODO: What do we want in the results? Number of turns, score/max, remaining deck, if any, # strikes, # clues

// MARK: Previews

// TODO: May need to update this. In the real app, the model will be updated by the previous view, setting the type of game.
// Currently, this preview is running an empty model, which gets updated in onAppear() to create a new, default game with model.makeGame().
// So, all we see is the default game (2 players, random deck).

/// A preview of the one-game view.
struct OneGameView_Previews: PreviewProvider {
    /// The model for this app.
    static var model = Model()

    static var previews: some View {
        NavigationView {
            OneGameView().environmentObject(model)
        }
    }
}
