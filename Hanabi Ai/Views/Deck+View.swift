//
//  Deck+View.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An `extension` of `Deck` for view-related functionality.
extension Deck {
    /// A `Text` that shows a `Deck`'s cards, with color.
    var coloredText: Text {
        self.cards.coloredText
    }
}
