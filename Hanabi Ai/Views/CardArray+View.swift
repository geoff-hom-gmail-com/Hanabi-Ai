//
//  Array+Card.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An `extension` of `[Card]` for view-related functionality.
extension Array where Element == Card {
    /// A `Text` which is the concatenation of each `Card`'s `coloredText`.
    var coloredText: Text {
        /// An `Array` of each `Card`'s `coloredText`.
        let coloredTexts = self.map {
            $0.coloredText
        }
        
        return coloredTexts.concatenated()
    }
}
