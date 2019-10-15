//
//  Suit+View.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An extension of Suit for view-related functionality.
extension Suit {
    /// A font/foreground color for the suit.
    ///
    /// The color was tested on white background. TODO: How to handle Dark Mode? Google it. Test.
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
    
    /// A text that shows the suit's letter, with color.
    var coloredLetter: Text {
        Text("\(letter)")
            .foregroundColor(color)
    }
    
    /// A text that shows each suit's letter, in suit order.
    static var allLettersText: Text {
        let suitLetters = allCases.sorted().map {
            $0.coloredLetter
        }
        return suitLetters.concatenated(withSeparator: "/")
    }
}
