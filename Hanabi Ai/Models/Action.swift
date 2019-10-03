//
//  Action.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/2/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

enum ActionType {
    case play, discard, clue
    
    /// Abbreviation for showing the action type.
    var abbr: String {
        let tempString: String
        switch self {
        case .play:
            tempString = "P"
        case .discard:
            tempString = "D"
        case .clue:
            tempString = "C"
        }
        return tempString
    }
}

/// In Hanabi, there are 3 actions: play/discard/clue. Play/discard is a card from your hand. Clue is to another player, revealing all of a number or a color/suit.
struct Action {
    let type: ActionType
    let card: Card?
    let number: Int?
    let suit: Suit?
    
    init(type: ActionType, card: Card? = nil, number: Int? = nil, suit: Suit? = nil) {
        self.type = type
        self.card = card
        self.number = number
        self.suit = suit
    }
}
