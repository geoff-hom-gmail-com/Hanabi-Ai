//
//  ActionType.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/14/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A type of action a player can do.
enum ActionType {
    /// The 3 types of actions.
    case play, discard, clue
    
    // TODO: follow "Suit" with Suit and use raw values of P/D/C? Would make abbr obsolete.
    // Do it if I need to make an action from a string (or rawValue).
    
    /// A string that uses an abbreviation to describe the action type.
    var abbr: String {
        switch self {
        case .play:
            return "P"
        case .discard:
            return "D"
        case .clue:
            return "C"
        }
    }
}

