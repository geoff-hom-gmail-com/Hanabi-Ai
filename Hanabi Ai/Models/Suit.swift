//
//  Suit.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A suit for a Hanabi card.
///
/// This is often called the color (e.g., green). However, an optional 6th suit is "Rainbow." And for colorblind players, each suit in the physical game has an associated kanji.
enum Suit: CaseIterable, Comparable {
    /// Returns a Bool that reflects whether one `Suit` is `<` another.
    ///
    /// For `Comparable`.
    static func < (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.sortIndex < rhs.sortIndex
    }
    
    /// The different suits, in terms of color.
    case green, red, white, blue, yellow
    
    /// A String that describes the Suit using one letter.
    var letter: String {
        /// A `String` that holds the `return` value, to avoid multiple `return`s.
        let returnString: String
        
        switch self {
        case .green:
            returnString = "g"
        case .red:
            returnString = "r"
        case .white:
            returnString = "w"
        case .blue:
            returnString = "b"
        case .yellow:
            returnString = "y"
        }
        return returnString
    }
    
    /// The order of each suit, for `Comparable`.
    ///
    /// The order is important not because suits trump each other. Rather, the score piles are displayed in a consistent order for legibility. The order is in honor of RWBY (i.e., gRWBY).
    var sortIndex: Int {
        /// An `Int` that holds the `return` value, to avoid multiple `return`s.
        let returnInt: Int
        
        switch self {
        case .green:
            returnInt = 0
        case .red:
            returnInt = 1
        case .white:
            returnInt = 2
        case .blue:
            returnInt = 3
        case .yellow:
            returnInt = 4
        }
        return returnInt
    }
}
