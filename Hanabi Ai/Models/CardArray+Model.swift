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
    
    // got string: g1g1g1g2g2g3g3g4g4g5r1r1r1r2r2r3r3r4r4r5w1w1w1w2w2w3w3w4w4w5b1b1b1b2b2b3b3b4b4b5y1y1y1y2y2y3y3y4y4y5
    
}
