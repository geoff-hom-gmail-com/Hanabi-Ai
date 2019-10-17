//
//  Model.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/16/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// TODO: We may not need this, though a lot of examples seem to use this idea of setting a model in the scene delegate.
/// A class for storing the data.
class Model: ObservableObject {
    /// The number of players.
    let numberOfPlayers: Int

    /// The method of arranging the deck; e.g., randomly, or with a specific order.
    let deckSetup: DeckSetup
    
    /// A human-readable description of the starting deck, used if the deck setup is "custom".
    let customDeckDescription: String
    
//    var game: Game
    
    lazy var game2 = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup)
    
//    var game3: Game?
    
    @Published var game4: Game?
//    var game3 = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup)
    
    // doesn't work; can't be published and lazy
//    @Published lazy var game3 = Game(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup)
    
    /// Creates a model with ??.
    init(numberOfPlayers: Int, deckSetup: DeckSetup, customDeckDescription: String = "") {
        print("Model.init() called")
        self.numberOfPlayers = numberOfPlayers
        self.deckSetup = deckSetup
        self.customDeckDescription = customDeckDescription
        
    }
}
