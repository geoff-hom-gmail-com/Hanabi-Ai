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
    
    /// A subscriber that publishes changes from the current game.
    var gameSubscriber: AnyCancellable? = nil
    
    /// The number of games to play in a row, if that mode was chosen.
    @Published var numberOfGames = 10
    
    /// Temp string, until TextField becomes easier to enter numbers.
    var numberOfGamesString = "10"

    /// The stats from playing multiple games in a row.
    @Published var stats = Stats()
    
    /// A subscriber that publishes changes from the stats.
    var statsSubscriber: AnyCancellable? = nil
    
    /// Makes an instance and subscribes to its game and stats.
    init() {
        /// We won't normally use the initiallly created game, but it's good for testing.
        gameSubscriber = game.objectWillChange.sink {
            self.objectWillChange.send()
        }
        
        statsSubscriber = stats.objectWillChange.sink{
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
    
    /// TODO: temp. Updates the number of games based on the user-entered string.
    func updateNumberOfGames() {
        // if valid int, update.
        if let number = Int(numberOfGamesString) {
            numberOfGames = number
        }
    }
    
    /// Plays multiple games in a row.
    func playGames() {
        /// The current system time. This is fast and simple (e.g., see https://kandelvijaya.com/2016/10/25/precisiontiminginios/).
        let startTime = CFAbsoluteTimeGetCurrent()
        
        stats.minScore = 26
        stats.maxScore = -1
        
        (1...numberOfGames).forEach { _ in
            makeGame()
            gameSubscriber = nil
            game.play()
            stats.gamesPlayed += 1
            
            // The current game's score.
            let score = game.endSetup!.scorePiles.score()
            
            if score < stats.minScore {
                stats.minScore = score
                stats.minDeck = game.startingDeck.description
            }
            if score > stats.maxScore {
                stats.maxScore = score
                stats.maxDeck = game.startingDeck.description
            }
            stats.totalScore += score
        }
        stats.computeTime = CFAbsoluteTimeGetCurrent() - startTime
        print("Worst: \(stats.minScore) (Deck: \(stats.minDeck))")
        print("Best: \(stats.maxScore) (Deck: \(stats.maxDeck))")
    }
}
