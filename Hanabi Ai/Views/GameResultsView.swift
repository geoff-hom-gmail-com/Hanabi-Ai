//
//  GameResults.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/18/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

// TODO: I could pass indata when I call this. And I guess that's fine to init the view. But we may have a long game, so we'd like to show stuff as it's being done, turn by turn
struct GameResultsView: View {
    var game: Game
//    var numberOfPlayers: Int
//    var deckSetup: DeckSetup
//    var customDeckDescription: String
    // Who owns the game? This view can for now.
    // So, we need to somehow make a game from what we were passed.
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String) {
        
        self.game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
        //game.deal()
        // then below, it'd be fun to have a button "Play", and then to see it spit out all the turns really fast.
    }
    
    var body: some View {
        Form {
            Section(header: Text("Deck")) {
                Text("r1g2…")
                    .font(.caption)
            }
            Section(header: Text("Starting Setup")) {
                HStack {
                    Text("P1: r1r1r1r2r2")
                    Text("P2: r1r1r2r4r3")
                }
                Text("Deck: r4g2…")
                    .font(.caption)
            }
            Section(header: Text("Turns")) {
                // If this Hstack is commented out, then it compiles in time.
//                HStack {
//                    // Ugh. Lining stuff up can be done with GR and PreferenceKey, which is available but undocumented. Will wait for Apple to document better and move on to other stuff.
//                    Text("Turn").underline()
//                        .background(Color.red.opacity(0.2))
//
                // Can I group, then underline, then wrap that in an Hstack? try it?
//                    HStack {
//                        Text("g").underline().foregroundColor(.green)
//                        Text("r").underline().foregroundColor(.red)
//                        Text("w").underline().foregroundColor(.gray)
//                        Text("b").underline().foregroundColor(.blue)
//                        Text("y").underline().foregroundColor(.yellow)
//                    }
//                    .background(Color.gray.opacity(0.2))
//
//                    HStack {
//                        Text("c").underline()
//                        Text("s").underline()
//                    }
//                    .background(Color.blue.opacity(0.2))
//                }
                    
                //TODO: Figure out how to subview this. Want it underlined, but custom subview doesn't like that.
//                HStack {
//                    PlayerHandsView(p1: "r1r2r2r4r5", p2: "w1w2s3s4w5")
//                    ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
//                    TokenPilesView(clues: 8, strikes: 0)
//                }
//                .font(.caption)
                
                
                // I want the rows to line up. E.g., Turn takes up 40% of row, grwby takes 40%, cs takes 20%
                
                // Here, I want a turn line. Need to make a subview. and it has to get its info from elsewhere
                // TODO: make subview, getting data from Game.??
                // TODO: embed in a list (extract line into subview first)
                HStack {
                    TurnNumberView(turn: 1)
                    PlayerActionsView(p1: "p.r1", p2: "p.g1")
                    PlayerHandsView(p1: "r1r2r3r4r5", p2: "w1w2s3s4w5")
                    ScorePilesView(green: 0, red: 1, white: 1, blue: 0, yellow: 0)
                    TokenPilesView(clues: 8, strikes: 0)
                }
                .font(.caption)
            }
            Section(header: Text("Results")) {
                Text("r1g2…")
                    .font(.caption)
            }
        }
        .navigationBarTitle(Text("Game Results"), displayMode: .inline)
    }
}

//struct TurnNumberView2: View {
//    let turn
//    var body: some View {
//        Text("\(turn).")
//    }
//}

struct TurnNumberView: View {
    let turn: Int
    var body: some View {
        Text("\(turn).")
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

struct PlayerHandsView: View {
    let p1: String
    let p2: String
    var body: some View {
        VStack {
            // make unique ids somehow?
            ForEach([p1, p2], id: \.self) { hand in
                Text("\(hand)")
            }
        }
    }
}

struct ScorePilesView: View {
    let greenScore: Int
    let redScore: Int
    let whiteScore: Int
    let blueScore: Int
    let yellowScore: Int
//    let body2: some View
    
    init(green: Int, red: Int, white: Int, blue: Int, yellow: Int) {
        
        self.greenScore = green
        self.redScore = red
        self.whiteScore = white
        self.blueScore = blue
        self.yellowScore = yellow
        
//        self.body2 = HStack {
//            Text("\(greenScore)").foregroundColor(.green)
//            Text("\(redScore)").foregroundColor(.red)
//            Text("\(whiteScore)").foregroundColor(.gray)
//            Text("\(blueScore)").foregroundColor(.blue)
//            Text("\(yellowScore)").foregroundColor(.yellow)
//        }
    }
    
    var body: some View {
        HStack {
            Text("\(greenScore)").foregroundColor(.green)
            Text("\(redScore)").foregroundColor(.red)
            Text("\(whiteScore)").foregroundColor(.gray)
            Text("\(blueScore)").foregroundColor(.blue)
            Text("\(yellowScore)").foregroundColor(.yellow)
        }
        .background(Color.gray.opacity(0.2))
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

struct GameResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameResultsView(numberOfPlayers: 2, deckSetup: .random, customDeckDescription: "")
        }
    }
}
