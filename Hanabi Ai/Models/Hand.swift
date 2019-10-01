//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// Custom string interpolations don't compile in SwiftUI (as of Xcode 11.0). (Nor does CustomStringConvertible.)
//extension String.StringInterpolation {
//    mutating func appendInterpolation(_ value: Hand) {
//        appendInterpolation("My name is \(value.player) and ")
//    }
//}

// A player's cards.
struct Hand: Identifiable {    
    let id = UUID()
    let player: String
    var cards: [String] = []
    
    // E.g., "P1: g3r1r3…"
    var description: String {
        let compact = cards.joined(separator: "")
        return "\(player): \(compact)"
    }
    
    // E.g., "g3/r1/r3…"
    var cardsDescription: String {
        let compact = cards.joined(separator: "/")
        return "\(compact)"
    }
}
