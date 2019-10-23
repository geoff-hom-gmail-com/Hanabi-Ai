//
//  CardArray+Model.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/19/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// An array-of-cards extension, for model-related functionality.
extension Array where Element == Card {
    /// A string that describes the concatenation of each card's description.
    var description: String {
        map{$0.description}.joined()
    }
}
