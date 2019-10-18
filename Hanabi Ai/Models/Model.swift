//
//  Model.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/16/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// This app's data.
class Model: ObservableObject {
    /// The next game's number of players.
    @Published var numberOfPlayers = 2

    /// The next game's deck setup.
    @Published var deckSetup = DeckSetup.random
    
    /// The next game's deck order if the deck setup is "custom."
    ///
    /// This isn't implemented yet, but it should be a human-readable string, so one can test it manually.
    @Published var customDeckDescription = ""
    
    /// The current game.
    @Published var game = Game()
    
    /// Creates a model.
    init() {
        print("Model.init() called")
    }
    
    /// Replaces the current game with a new one.
    func makeGame() {
        game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
    }
}
