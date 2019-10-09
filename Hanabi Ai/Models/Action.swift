//
//  Action.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/2/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A type of action a player can do.
enum ActionType {
    /// The 3 types of actions.
    case play, discard, clue
    
    /// A `String` that describes the action type.
    var abbr: String {
        /// A `String` that holds the `return` value, to avoid multiple `return`s.
        let returnString: String
        
        switch self {
        case .play:
            returnString = "P"
        case .discard:
            returnString = "D"
        case .clue:
            returnString = "C"
        }
        return returnString
    }
}

/// A player's action.
///
/// In Hanabi, there are 3 actions: play/discard/clue. Play/discard is a card from your hand. Clue is to another player, revealing all of a number or all of a color/suit.
struct Action {
    /// The type of action.
    let type: ActionType
    
    /// The card chosen (if play/discard; else, `nil`).
    let card: Card?
    
    /// The number chosen (if clue; else, `nil`).
    let number: Int?
    
    /// The suit chosen (if clue; else, `nil`).
    let suit: Suit?
    
    /// Creates an `Action` with the given `type`, `card`, `number`, and `suit`.
    init(type: ActionType, card: Card? = nil, number: Int? = nil, suit: Suit? = nil) {
        self.type = type
        self.card = card
        self.number = number
        self.suit = suit
    }
    
    // TODO: If 3+ players, clues need to indicate target player. We don't want this for 2-player games, because that's obvious.
    /// A `String` that describes the action unambiguously.
    ///
    /// E.g., "P.r1," "D.w3," "C.p1.3," "C.p3.r," "C.g," "C.3"
    var abbr: String {
        /// The type's abbreviation.
        let typeAbbr = type.abbr
        
        /// A `String` that holds the `return` value, to avoid multiple `return`s.
        var returnString: String
        
        switch type {
        case .play, .discard:
            returnString = "\(typeAbbr).\(card!.description)"
        case .clue:
            /// A String that describes the type of clue given.
            let clueString: String
            
            // If `number` exists, use that. Else, it must be a `suit`, so describe that.
            if let number = number {
                clueString = "\(number)"
            } else {
                clueString = "\(suit!.letter)"
            }
            returnString = "\(typeAbbr).\(clueString)"
        }
        return returnString
    }
}
