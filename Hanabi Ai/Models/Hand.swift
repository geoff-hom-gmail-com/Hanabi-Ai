//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// A player's cards.
// TODO: struct Hand {
struct Hand: Identifiable {
    let id = UUID()
    let player: String
    var cards: [Card] = []
}
