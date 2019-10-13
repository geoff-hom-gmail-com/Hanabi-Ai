//
//  Suit.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi card's suit.
///
/// This is often called the color (e.g., green). However, an optional 6th suit is "Rainbow." And for colorblind players, each suit in the physical game has an associated kanji.
enum Suit: CaseIterable, Comparable {
    /// The available suits, by color.
    case green, red, white, blue, yellow
    
    /// A string of one letter that describes the suit.
    var letter: String {
        switch self {
        case .green:
            return "g"
        case .red:
            return "r"
        case .white:
            return "w"
        case .blue:
            return "b"
        case .yellow:
            return "y"
        }
    }
    
    // MARK: Comparable
    
    /// Returns a Boolean value that indicates whether the first specified suit is "less than" the other.
    ///
    /// For `Comparable`.
    static func < (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.sortIndex < rhs.sortIndex
    }
    
    /// An integer that indicates the relative order of each suit.
    ///
    /// For `Comparable`. The order is important not because suits trump each other. Rather, the score piles are displayed in a consistent order for legibility. The order is in honor of RWBY (i.e., gRWBY).
    var sortIndex: Int {
        switch self {
        case .green:
            return 0
        case .red:
            return 1
        case .white:
            return 2
        case .blue:
            return 3
        case .yellow:
            return 4
        }
    }
}
