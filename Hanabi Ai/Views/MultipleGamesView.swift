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
                // TODO: This is the wrong play function. Should be like model.playGames()
                PlayButtonView(playFunction: model.game.play)
            }
            Section(header: Text("Games")) {
                Text("header? see notebook")
                // TODO: If we follow OGV, then we should lay out what we want here, and have dummy/empty data at the start.
                // Like, it would say 0 games played
                // Time taken: 0
                // Games won: 0%. Score (avg): 0
                // Figure out where in model I store data for multiple games
                // It should be like a struct for stats, like model.stats.gamesPlayed, .stats.gamesWon, .stats.score
            }
        }
        .navigationBarTitle(Text("Multiple Games"), displayMode: .inline)
        .onAppear {
            print("onAppear called")
            // todo: set number of games (int) from string. update # games shown above.
//            self.model.makeGame()
        }
        .onDisappear {
            print("onDisappear called")
            // We shouldn't need this, but the app would crash when playing a game, going back, then trying to play a new game. Creating an unplayed game, below, fixed it.
//            self.model.game = Game()
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
