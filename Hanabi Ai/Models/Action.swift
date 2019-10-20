//
//  Action.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/2/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's action.
///
/// In Hanabi, there are 3 actions: Play, Discard, and Clue. A player may play/discard a card from their hand. A player may also clue another player, revealing all of a number or all of a color/suit in their hand.
struct Action {
    /// The type of action.
    let type: ActionType
    
    /// The card chosen if the action is play/discard; else, `nil`.
    let card: Card?
    
    /// The number chosen if the action is clue; else, `nil`.
    let number: Int?
    
    /// The suit chosen if the action is clue; else, `nil`.
    let suit: Suit?
    
    /// Creates an action with the specified parameters.
    init(type: ActionType, card: Card?, number: Int?, suit: Suit?) {
        self.type = type
        switch self.type {
        case .play, .discard:
            self.card = card
            self.number = nil
            self.suit = nil
        case .clue:
            self.card = nil
            self.number = number
            self.suit = suit
        }
    }
    
    // TODO: If 3+ players, clues need to indicate target player. We don't want this for 2-player games, because that's obvious.
    /// A string that uses abbreviations to describe the action unambiguously.
    ///
    /// E.g., "P.r1," "D.w3," "C.p1.3," "C.p3.r," "C.g," "C.3"
    var abbr: String {
        /// The type's abbreviation.
        let typeAbbr = type.abbr
        
        switch type {
        case .play, .discard:
            return "\(typeAbbr).\(card!.description)"
        case .clue:
            /// A string that describes the type of clue given.
            let clueString: String
            
            // If a number exists, use that. Else, the clue must be a suit, so use that.
            if let number = number {
                clueString = "\(number)"
            } else {
                clueString = "\(suit!.rawValue)"
            }
            return "\(typeAbbr).\(clueString)"
        }
    }
}
