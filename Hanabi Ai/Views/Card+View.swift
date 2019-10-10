//
//  Card+View.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An `extension` of `Card` for view-related functionality.
extension Card {
    /// A `Text` that shows a `Card`'s description, with color.
    var coloredText: Text {
        Text("\(self.description)")
            .foregroundColor(self.suit.color)
    }
}
