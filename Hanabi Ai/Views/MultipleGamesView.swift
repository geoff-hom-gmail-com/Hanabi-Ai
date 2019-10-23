//
//  MultipleGamesView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/23/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct MultipleGamesView: View {
    /// The model for this app.
    @EnvironmentObject var model: Model

    var body: some View {
        Form {
            Section(header: Text("Setup")) {
                Text("Players: \(model.numberOfPlayers)")
                Text("Deck Setup: \(model.deckSetup.name)")
                Text("AI: \(Model.AIs[model.aiIndex].name)")
                Text("Games: \(model.numberOfGames)")
                PlayButtonView(playFunction: model.playGames)
            }
            Section(header: Text("Results")) {
                HStack {
                    Text("Games: \(model.stats.gamesPlayed)")
                    Divider()
                    Text(#"Time: \#(model.stats.computeTime, specifier: "%.1f")""#)
                    Divider()
                    Text("Mean score: \(model.stats.meanScore, specifier: "%.1f")")
                }
                Text("Worst: \(model.stats.minScore) (Deck: \(model.stats.minDeck))")
                Text("Best: \(model.stats.maxScore) (Deck: \(model.stats.maxDeck))")
            }
            .font(.caption)
        }
        .navigationBarTitle(Text("Multiple Games"), displayMode: .inline)
        .onAppear {
//            print("onAppear called")
            
            // TODO: Temp workaround: In APV, we don't check user-entered "number of games" for validity. So we do it here.
            self.model.updateNumberOfGames()
        }
        .onDisappear {
//            print("onDisappear called")
            
            // We shouldn't need this, but the app would crash when playing a game, going back, then trying to play a new game. Creating an unplayed game, below, fixed it.
            self.model.game = Game()
        }
    }
}

struct MultipleGamesView_Previews: PreviewProvider {
    /// The model for this app.
    static var model = Model()

    static var previews: some View {
        NavigationView {
            MultipleGamesView().environmentObject(model)
        }
    }
}
