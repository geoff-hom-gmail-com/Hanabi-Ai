//
//  TextArray+Concatenated.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// A text-array extension.
extension Array where Element == Text {
    /// Returns a text that is the concatenation of each text in the array.
    ///
    /// If a separator is specified, it's inserted between each text.
    func concatenated(withSeparator separator: String? = nil) -> Text {
        /// A mutable copy.
        var array = self
        
        // The first text, for `reduce`.
        let firstText = array.removeFirst()
        
        guard let separator = separator else {
            return array.reduce(firstText, +)
        }
        return array.reduce(firstText, { x, y in
            x + Text(separator) + y
        })
    }
}
