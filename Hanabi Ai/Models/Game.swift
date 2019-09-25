//
//  Game.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

enum DeckSetup: CaseIterable, Identifiable {
    // TODO: later, could have options like "hard," "easy"; will have to figure out how to make those
    case random, custom

    var id: DeckSetup { self }
    
    var name: String {
        switch self {
        case .random:
            return "Random"
        case .custom:
            return "Custom"
        }
    }
}

struct Game {
    // Returns a string defining a random deck.
    static var randomDeckDescription: String {
        var deck = Deck()
        deck.shuffle()
        let description = deck.description
        return description
    }
    
    var numberOfPlayers: Int = 2
    var deckSetup: DeckSetup = .random
    var customDeckDescription: String = ""
//    var deck: Deck
}
