//
//  Suit.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi card has a suit (i.e., color).
// todo: mention rainbow, kanji
enum Suit: CaseIterable, Comparable {
    static func < (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.sortIndex < rhs.sortIndex
    }
    
    case green, red, white, blue, yellow
    
    /// For clarity (e.g., colorblindness), the suit is always shown by at least a letter. E.g., cards "r1", "g3".
    var letter: String {
        let tempString: String
        switch self {
        case .green:
            tempString = "g"
        case .red:
            tempString = "r"
        case .white:
            tempString = "w"
        case .blue:
            tempString = "b"
        case .yellow:
            tempString = "y"
        }
        return tempString
    }
    
    // The order is in honor of RWBY (i.e., gRWBY).
    var sortIndex: Int {
        let tempInt: Int
        switch self {
        case .green:
            tempInt = 0
        case .red:
            tempInt = 1
        case .white:
            tempInt = 2
        case .blue:
            tempInt = 3
        case .yellow:
            tempInt = 4
        }
        return tempInt
    }
}
