//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// Player's cards.
struct Hand: Identifiable {
    let id = UUID()
    let player: String
    var cards: [String] = []
    
    // E.g., "P1: g3r1r3…"
    var description: String {
        let compact = cards.joined(separator: "")
        return "\(player): \(compact)"
    }
}
