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
    /// This is a human-readable string, so one can check it manually.
    @Published var customDeckDescription = Deck.suitOrderedString
    
    /// The available AIs.
    static let AIs: [AI] = [PlayFirstCardAI(), PlaySecondCardAI(), FirstPlayableAI(), DiscardFirstAI()]
    
    /// The `AIs` index to use in the next game.
    @Published var aiIndex = AIs.firstIndex { $0 is PlayFirstCardAI }!
    
    /// The current game.
    @Published var game = Game()
    
    /// The number of games to play in a row, if that mode was chosen.
    @Published var numberOfGames = 10
    
    /// Temp string, until TextField becomes easier to enter numbers.
    @Published var numberOfGamesString = "10"

    /// A subscriber that publishes changes from the current game.
    var gameSubscriber: AnyCancellable? = nil
    
    /// Makes an instance.
    ///
    /// We won't normally use the initiallly created game, but it's good for testing.
    init() {
        gameSubscriber = game.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
    
    /// Replaces the current game with a new one.
    ///
    /// Also subscribes to the new game.
    func makeGame() {
        game = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription, aiIndex: aiIndex)
        
        // Learning about Combine: objectWillChange is the Publisher from ObservableObject.
        // sink(receiveValue:) creates and returns a subscriber to the publisher.
        // In this case, when the game will change, the model says it will also change.
        gameSubscriber = game.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
}
