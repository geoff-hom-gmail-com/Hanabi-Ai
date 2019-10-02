//
//  OneGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/18/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

// Interface for auto-playing one game.
struct OneGameView: View {
    @ObservedObject var game: Game
    
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String) {
        let game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
        self.game = game
    }
    
    var body: some View {
        Form {
            DeckSetupSection(deckSetup: game.deckSetup, startingDeck: game.startingDeck)
            StartingSetupSection(game: game)
            TurnsSection(turns: game.turns)
            ResultsSection()
        }
        .navigationBarTitle(Text("One Game"), displayMode: .inline)
    }
}

// MARK: DeckSetupSection

// Deck setup and deck used.
struct DeckSetupSection: View {
    var deckSetup: DeckSetup
    var startingDeck: Deck
    var body: some View {
        Section(header: Text("Deck Setup")) {
            // initialString has non-breaking space.
            ColoredCardsText(initialString: "\(deckSetup.name): ", cards: startingDeck.cards)
                .font(.caption)
        }
    }
}

// MARK: StartingSetupSection

/// The game state after dealing hands, plus the "Play" button.
struct StartingSetupSection: View {
    let game: Game
    let turn: Turn
    init(game: Game) {
        self.game = game
        self.turn = self.game.turns.first!
    }
    var body: some View {
        Section(header: Text("Starting Setup")) {
            StartingHandsAndDeckGroup(hands: turn.hands, deck: turn.deck)
            PlayButton(game: game)
        }
    }
}

/// The starting hands, and the remaining deck.
struct StartingHandsAndDeckGroup: View {
    let hands: [Hand]
    let deck: Deck
    var body: some View {
        Group {
            HStack(spacing: 0) {
                Text("Hands: ")
                VStack(alignment: .leading) {
                    ForEach(hands) {
                        ColoredCardsText(cards: $0.cards)
                    }
                }
            }
            // initialString has non-breaking space.
            ColoredCardsText(initialString: "Deck: ", cards: deck.cards)
                .font(.caption)
        }
        .font(.caption)
    }
}

// This returns Text, but it won't let me put that in the sig. So it doesn't allow Text modifiers externally.
/// Card descriptions, in a row, colored by suit.
struct ColoredCardsText: View {
    var initialString: String = ""
    var cards: [Card]
    // Emphasis is here, because don't know how to add Text modifiers to ColoredCardsText. (Won't compile.)
    var emphasis: Bool = false
    var body: some View {
        // Make a Text for each card. Then concatenate them.
        let coloredCards = cards.map {
            Text("\($0.description)")
                .foregroundColor(colorForSuit($0.suit))
        }
        var text: Text = coloredCards.reduce(Text(initialString), +)
        if emphasis {
            text = text.bold()
        }
        return text
    }
}

/// The color to represent each suit.
func colorForSuit(_ suit: Suit) -> Color {
    var color: Color
    switch suit {
    case .green:
        color = .green
    case .red:
        color = .red
    case .white:
        color = .gray
    case .blue:
        color = .blue
    case .yellow:
        color = .yellow
    }
    return color
}

/// Starts playing the game that was set up.
struct PlayButton: View {
    let game: Game
    var body: some View {
        HStack {
            Spacer()
            Button(action: { self.game.play() }) {
                Text("Play")
            }
            Spacer()
        }
    }
}

// MARK: TurnsSection

/// Each turn in the game.
struct TurnsSection: View {
    let turns: [Turn]
//    let turns: [Turn] = []
    var body: some View {
        Section(header: TurnsSectionHeaderView()) {
            TurnHeaderView()
            //TODO: add placeholder turns. In the end, we'll add them by drawing from Turns.
            ForEach(turns, id: \.number) {
                TurnView(turn: $0)
            }
            //            TurnView1()
            //            TurnView2()
            //            TurnView3()

            //                    // Ugh. Lining stuff up can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
            // I want the rows to line up. E.g., Turn takes up 40% of row, grwby takes 40%, cs takes 20%
        }
    }
}

/// The text for the section header.
struct TurnsSectionHeaderView: View {
    // TODO: Add legend to UI via popover/context button, if that's doable on iPhone
    var body: some View {
        Text("Turns")
//        + Text(" (g/r/w/b/y: green/red/white/blue/yellow)")
//        + Text(" (C/S/D: Clues/Strikes/Deck)")
    }
}

/// Field descriptions for each turn.
struct TurnHeaderView: View {
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

/// Abbreviation for each color, in order.
struct ScoreHeaderView: View {
    /// Text for each color, in order. Includes dividers.
    var sortedTexts: [Text] = []
    
    /// Order the suits. Add color. Add divider.
    init() {
        let sortedSuits = Suit.allCases.sorted()
        for sortedSuit in sortedSuits {
            let text = Text("\(sortedSuit.letter)").foregroundColor(colorForSuit(sortedSuit))
            if !sortedTexts.isEmpty {
                sortedTexts.append(Text("/"))
            }
            sortedTexts.append(text)
        }
    }
    
    var body: some View {
        sortedTexts.reduce(Text(""), +)
    }
}

/// Info needed to understand a turn.
struct TurnView: View {
    let turn: Turn
    var body: some View {
        HStack {
            TurnNumberView(number: turn.number)
            PlayerHandsView(hands: turn.hands, currentHandID: turn.currentHandID)
            ScorePilesView(scores: turn.scores)
            TokenPilesView(clues: turn.clues, strikes: turn.strikes, cardsInDeck: turn.deck.cards.count)
            ActionView(hands: turn.hands, currentHandID: turn.currentHandID)
        }
        .font(.caption)
    }
}

// Info needed to understand each turn.
//struct TurnView1: View {
//    let turn: Turn = Turn(hands:
//        [Hand(player: "P1", cards: ["r1","w2","r3","r4","r5"]), Hand(player: "P2", cards: ["w1","r2","s3","s4","w5"])],
//                          deck: Deck())
//    var body: some View {
//        HStack {
//            TurnNumberView(turn: 1)
//            PlayerHandsView(hands: turn.hands)
//            ScorePilesView(scores: turn.scores)
//
////            ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
//            TokenPilesView(clues: turn.clues, strikes: turn.strikes)
//
////            TokenPilesView(clues: 8, strikes: 0)
//            // TODO: Extract to DeckCountView()
//            Text("40")
//            // TODO: Extract Subview
//            VStack {
//                Text("p.r1")
//                Text("\n")
//            }
//        }
//        .font(.caption)
//    }
//}

// Info needed to understand each turn.
//struct TurnView2: View {
//    var body: some View {
//        HStack {
//            TurnNumberView(turn: 2)
//            //TODO: Can highlight the current player, and action
////            PlayerHandsView(p1: "w2/r3/r4/r5/g1", p2: "w1/r2/s3/s4/w5")
////            ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
//            TokenPilesView(clues: 8, strikes: 0)
//            Text("39")
//            VStack {
//                Text("\n")
//                Text("p.r2")
//            }
//        }
//        .font(.caption)
//    }
//}

// Info needed to understand each turn.
//struct TurnView3: View {
//    var body: some View {
//        HStack {
//            TurnNumberView(turn: 3)
//            //TODO: Can highlight the current player, and action
////            PlayerHandsView(p1: "w2,r3,r4,r5,g1", p2: "w1r2s3s4w5")
////            ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
//            TokenPilesView(clues: 8, strikes: 0)
//            Text("39")
//            VStack {
//                Text("\n")
//                Text("p.r2")
//            }
//        }
//        .font(.caption)
//    }
//}

/// Which turn it is.
struct TurnNumberView: View {
    let number: Int
    var body: some View {
        Text("\(number).")
    }
}

/// The players' cards. Current player is highlighted.
struct PlayerHandsView: View {
    let hands: [Hand]
    let currentHandID: UUID
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(hands) { hand in
                ColoredCardsText(cards: hand.cards, emphasis: hand.id == self.currentHandID)
            }
        }
    }
}

/// The score for each color.
struct ScorePilesView: View {
    /// Text for each score, in order. Includes dividers.
    var sortedTexts: [Text] = []
    
    /// Order the scores. Add color. Add divider.
    init(scores: [Suit: Int]) {
        let sortedSuits = scores.keys.sorted()
        for sortedSuit in sortedSuits {
            let score = scores[sortedSuit]!
            let text = Text("\(score)").foregroundColor(colorForSuit(sortedSuit))
            if !sortedTexts.isEmpty {
                sortedTexts.append(Text("/"))
            }
            sortedTexts.append(text)
        }
    }
    
    var body: some View {
        sortedTexts.reduce(Text(""), +)
    }
}

/// Number of clues, strikes, cards in deck.
struct TokenPilesView: View {
    let clues: Int
    let strikes: Int
    let cardsInDeck: Int
    var body: some View {
        Text("\(clues)/\(strikes)/\(cardsInDeck)")
//        .background(Color.blue.opacity(0.2))
    }
}

/// Current player's action. Highlighted, to match highlighted hand.
struct ActionView: View {
    // TODO: Eventually, we'll need the action (p/c/d)
    let hands: [Hand]
    let currentHandID: UUID
    var body: some View {
        VStack {
            ForEach(hands) { hand in
                if hand.id == self.currentHandID {
                    Text("??").bold()
                } else {
                    Text("\n")
                }
            }
        }
    }
}

//struct PlayerActionsView: View {
//    let p1: String
//    let p2: String
//    var body: some View {
//        VStack {
//            // TODO: ah, this needs to have unique IDs, and right now, that's not true (could be c c). Fix.
//            ForEach([p1, p2], id: \.self) { action in
//                Text("\(action)")
//            }
//        }
//        .background(Color.red.opacity(0.2))
//    }
//}

// MARK: ResultsSection

// The end of the game, or a summary.
struct ResultsSection: View {
    var body: some View {
        Section(header: Text("Results")) {
            Text("??")
                .font(.caption)
        }
    }
}

struct OneGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OneGameView(numberOfPlayers: 2, deckSetup: .random, customDeckDescription: "")
        }
    }
}

