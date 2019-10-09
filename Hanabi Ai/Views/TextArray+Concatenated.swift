//
//  Array+Text.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An `extension` of `[Text]`.
extension Array where Element == Text {
    /// Returns a `Text` which is the concatenation of each `Text` in the `Array`, with an optional `separator` between each `Text`.
    func concatenated(withSeparator separator: String? = nil) -> Text {
        /// The first `Text`, which is before any `separator`.
        let firstText = self.first!
        
        /// The remaining `Text`s, which may be prefixed by a `separator`.
        let otherTexts = self.dropFirst()
        
        guard let separator = separator else {
            return otherTexts.reduce(firstText, +)
        }
        return otherTexts.reduce(firstText, { x, y in
            x + Text(separator) + y
        })
    }
}
