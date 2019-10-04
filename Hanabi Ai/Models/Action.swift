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
    
    /// Abbreviation for showing the action. E.g., "P.r1," "D.w3," "C.p1.3," "C.p3.r," "C.g," "C.3"
    var abbr: String {
        let typeAbbr: String = self.type.abbr
        var tempString: String
        switch self.type {
        case .play, .discard:
            tempString = "\(typeAbbr).\(self.card!.description)"
        case .clue:
            // If number, use that. Else, it must be a suit.
            let clueString: String
            if let number = self.number {
                clueString = "\(number)"
            } else {
                clueString = "\(self.suit!.letter)"
            }
            tempString = "\(typeAbbr).\(clueString)"
        }
        return tempString
    }
}
