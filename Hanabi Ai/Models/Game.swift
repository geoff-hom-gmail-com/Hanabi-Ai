//
//  Game.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/17/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

struct Game {
    // Returns a string defining a random deck.
    static var randomDeckDescription: String {
        let deck = Deck()
        deck.shuffle()
        let description = deck.description
        return description
    }

}
