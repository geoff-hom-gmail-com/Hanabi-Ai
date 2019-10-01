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
            DeckSetupSection(deckSetup: game.deckSetup, startingDeckDescription: game.startingDeckDescription)
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
    var startingDeckDescription: String
    var body: some View {
        Section(header: Text("Deck Setup")) {
            Text("\(deckSetup.name): \(startingDeckDescription)")
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
            VStack(alignment: .leading) {
                ForEach(hands) {
                    Text("\($0.description)")
                }
            }
            Text("Deck: \(deck.description)")
        }
        .font(.caption)
    }
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

// Show each turn in the game.
struct TurnsSection: View {
    let turns: [Turn]
//    let turns: [Turn] = []
    var body: some View {
        Section(header: Text("Turns (C: Clues, S: Strikes, D: Deck)")) {
            TurnHeaderView()
            //TODO: add placeholder turns. In the end, we'll add them by drawing from Turns.
            ForEach(turns, id: \.number) {
                TurnView(turn: $0)
            }
            //            TurnView1()
            //            TurnView2()
            //            TurnView3()

            //                HStack {
            //                    // Ugh. Lining stuff up can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
            // I want the rows to line up. E.g., Turn takes up 40% of row, grwby takes 40%, cs takes 20%
        }
    }
}

// The end of the game, or a summary.
struct ResultsSection: View {
    var body: some View {
        Section(header: Text("Results")) {
            Text("??")
                .font(.caption)
        }
    }
}



// Field descriptions for each turn.
struct TurnHeaderView: View {
    var body: some View {
        HStack {
            Text("Hands")
            Text("g").foregroundColor(.green)
            Text("r").foregroundColor(.red)
            Text("w").foregroundColor(.gray)
            Text("b").foregroundColor(.blue)
            Text("y").foregroundColor(.yellow)
            Text("C/S")
            Text("Deck")
            Text("Action")
        }
        .font(.caption)
    }
}

/// Info needed to understand a turn.
struct TurnView: View {
    let turn: Turn
    var body: some View {
        HStack {
            TurnNumberView(number: turn.number)
            PlayerHandsView(hands: turn.hands)
//            ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
            TokenPilesView(clues: 8, strikes: 0)
            Text("40")
            Text("p.r1")
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


// TODO: how does it know whose turn it is? need to pass in; except we don't have index control in swiftui loops; maybe: https://forums.developer.apple.com/thread/118361
// The players' cards. Also highlights current player.
struct PlayerHandsView: View {
    let hands: [Hand]
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(hands) {
                Text("\($0.cardsDescription)")
            }
        }
    }
}

// The score for each color.
struct ScorePilesView: View {
    var greenScore: Int = 0
    var redScore: Int = 0
    var whiteScore: Int = 0
    var blueScore: Int = 0
    var yellowScore: Int = 0
    
    init(scores: [Suit: Int]) {
        for (suit, score) in scores {
            switch suit {
            case .green:
                greenScore = score
            case .red:
                redScore = score
            case .white:
                whiteScore = score
            case .blue:
                blueScore = score
            case .yellow:
                yellowScore = score
            }
        }
    }
    
    var body: some View {
        // TODO: Could also do this as one line of text? Just use "/" as separator. I think I read somewhere you can join Text in SwiftUI with +.
        HStack {
            Text("\(greenScore)").foregroundColor(.green)
            Text("\(redScore)").foregroundColor(.red)
            Text("\(whiteScore)").foregroundColor(.gray)
            Text("\(blueScore)").foregroundColor(.blue)
            Text("\(yellowScore)").foregroundColor(.yellow)
        }
            // TODO: temp highlight? though it helps group; add corner radius?
        .background(Color.gray.opacity(0.1))
    }
}

struct TokenPilesView: View {
    let clues: Int
    let strikes: Int
    var body: some View {
        return HStack {
            Text("\(clues)")
            Text("\(strikes)")
        }
        .background(Color.blue.opacity(0.2))
    }
}

struct PlayerActionsView: View {
    let p1: String
    let p2: String
    var body: some View {
        VStack {
            // TODO: ah, this needs to have unique IDs, and right now, that's not true (could be c c). Fix.
            ForEach([p1, p2], id: \.self) { action in
                Text("\(action)")
            }
        }
        .background(Color.red.opacity(0.2))
    }
}


struct OneGameView_Previews: PreviewProvider {
//    static let hands = [Hand(player: "P1", cards: ["r1","w2","r3","r4","r5"]), Hand(player: "P2", cards: ["w1","r2","s3","s4","w5"])]
    static var previews: some View {
        NavigationView {
//            PlayerHandsView(hands: hands)
            OneGameView(numberOfPlayers: 2, deckSetup: .random, customDeckDescription: "")
        }
    }
}



