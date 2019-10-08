//
//  DeckSetup.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

///
//    /// A flag for how to arrange the deck; e.g., randomly, or with a custom order.
enum DeckSetup: CaseIterable, Identifiable {
    // TODO: later, could have options like "hard," "easy"; will have to figure out how to make those
    case random, custom

    var id: DeckSetup { self }
    
    var name: String {
        let tempString: String
        switch self {
        case .random:
            tempString = "Random"
        case .custom:
            tempString = "Custom"
        }
        return tempString
    }
}
