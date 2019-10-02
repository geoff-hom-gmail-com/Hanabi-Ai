//
//  Suit.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/1/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

// TODO: update Suit so it's more generic (use name instead of a raw string) (add sort order via Int, <?)
/// TODO: add description
enum Suit: String, CaseIterable {
    case green = "g"
    case red = "r"
    case white = "w"
    case blue = "b"
    case yellow = "y"
}
