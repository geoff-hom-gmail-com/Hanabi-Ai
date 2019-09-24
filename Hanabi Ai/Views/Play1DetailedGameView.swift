//
//  Play1DetailedGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

// TODO: This view is deprecated. It now goes from Auto-Play -> GameResults. Get rid of this view once the rest works.
struct Play1DetailedGameView: View {
    @State private var randomDeckDescription: String = Game.randomDeckDescription
    @State private var specificDeckDescription: String = ""

    var body: some View {
        // Using Form until .lineLimit(nil) starts working robustly.
        Form {
            Section {
                VStack {
                    Text("Random Deck:")
                    TextField("Deck contents: g3r2w4b1y5, etc.", text: $randomDeckDescription)
                        .font(.caption)
//                        .frame(idealHeight: .infinity)
                    // .lineLimit(nil) not working. Can wrap in UITextField, but it should work as-is. Waiting for Apple.
                    
                    // temp, until TextField.lineLimit(nil) works
                    Text(randomDeckDescription)
                        .font(.caption)
                        .lineLimit(nil)
                    
                    // Go to DetailedGameView. So, I should pass in the deck description.
                    // Though later, we'll pass in the parameters for the game, like # players. So, either I pass in the game, or the GRView knows about the game/model inherently. Former seems better.
//                    NavigationLink(destination: GameResultsView()) {
//                        Text("Go")
//                    }
                }
            }
//            .padding(.vertical)
            //            .background(Color.green)
            //            Divider()
            Section {
                VStack {
                    Text("Specific:")
                    TextField("Deck contents: e.g., g3r2w4b1y5…", text: $specificDeckDescription)
                        .font(.caption)
                    // I could seed this with the random deck. Or more likely, the last specific deck. If none, use the random deck.
                    
//                    NavigationLink(destination: GameResultsView()) {
//                        Text("Go")
//                    }
                }
//                .padding(.vertical)
            }
            //            .background(Color.blue)
        }
        .navigationBarTitle(Text("Play 1 Game"), displayMode: .inline)
    }
}

struct Play1DetailedGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Play1DetailedGameView()
        }
    }
}
