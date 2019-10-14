//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A player's cards.
// TODO: think more about the calls, and whether I want cards private, private(set), ability to add/remove cards by modifying cards directly, etc. What's most readable?
// hmm, now Hand2 isn't Identifiable. Arrays aren't Identifiable
typealias Hand = Array<Card>

//class Hand: Identifiable {
//    /// The cards.
//    var cards: [Card] = []
//
//    /// Adds the specified card to the hand.
//    func add(_ card: Card) {
//        cards += [card]
//    }
//    
//    /// Removes the specified card from the hand.
//    func remove(_ card: Card) {
//        cards.removeAll {
//            $0 === card
//        }
//    }
//}
