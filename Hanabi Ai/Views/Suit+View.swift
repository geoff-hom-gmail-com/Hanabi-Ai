//
//  Suit+Color.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An `extension` of `Suit` for view-related functionality.
extension Suit {
    /// A foreground `Color` for the `Suit`.
    ///
    /// The `Color` should work as a font/foreground color on white background. TODO: Test colors in Dark Mode?
    var color: Color {
        switch self  {
        case .green:
            return .green
        case .red:
            return .red
        case .white:
            // White doesn't show on white background.
            return .gray
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        }
    }
    
    /// A `Text` that shows a `Suit`'s `letter`, with color.
    var coloredText: Text {
        Text("\(self.letter)")
            .foregroundColor(self.color)
    }
}
