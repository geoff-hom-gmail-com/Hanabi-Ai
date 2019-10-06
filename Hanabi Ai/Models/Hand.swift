//
//  Hand.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 9/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// A player's cards.
// TODO: fix conflation. Hands do need to be identifiable, as the same hand in two positions is different. One option is to have an id/UUID. Another option is for Hands to be a dictionary/set (i.e. unordered), but the hand.position be a property. Another option is to have hand.playerPosition and have that bound to the hands array, so that when a hand is added to the array, it gets set, and when a hand is removed, it gets removed (and all the other hands are updated as well).
// So a question is where will our "truth" be for the hand's identity/position? The array position, or the hand.position property?
// Anyway, having a player name is confusing now. We're not even using it.
// The simplest way seems to have an Array of Hands, so that's ordered…then a hand's position would not be a property of the hand, but based on its array position. Then, outside the context of a Turn, which defines an array of hands, a hand is not identifiable. Makes sense.
// so, to get rid of the UUID/id and player, that's the TODO.

struct Hand: Identifiable {
    let id = UUID()
    let player: String
    var cards: [Card] = []
}
