//
//  Card+View.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// A card extension for view-related functionality.
extension Card {
    /// A text that shows a card's description, with color.
    var coloredText: Text {
        Text("\(description)")
            .foregroundColor(suit.color)
    }
}
