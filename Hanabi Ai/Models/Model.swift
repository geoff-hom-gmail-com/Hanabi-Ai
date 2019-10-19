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
    
    /// A subscriber that publishes changes from the current game.
    var gameSubscriber: AnyCancellable? = nil
    
    /// Replaces the current game with a new one.
    ///
    /// Also subscribes to the new game.
    func makeGame() {
        game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
        
        // Learning about Combine: objectWillChange is the Publisher from ObservableObject.
        // sink(receiveValue:) creates and returns a subscriber to the publisher.
        // In this case, when the game will change, the model says it will also change.
        gameSubscriber = game.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
}
