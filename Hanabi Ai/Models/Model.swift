//
//  Model.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/16/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import Combine

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
    
    /// comment
    var anyCancellable: AnyCancellable? = nil
    
    /// comment
    init() {
        print("model.init called")
        anyCancellable = game.objectWillChange.sink {
            print("game.objectWillChange sunk1")
            self.objectWillChange.send()
        }
    }
    
    /// Replaces the current game with a new one.
    func makeGame() {
        print("model.makeGame() called")
        game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
        anyCancellable = game.objectWillChange.sink {
            print("game.objectWillChange sunk2")
            self.objectWillChange.send()
        }
    }
}
