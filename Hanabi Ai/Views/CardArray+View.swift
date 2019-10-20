//
//  CardArray+View.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation
import SwiftUI

/// An array-of-cards extension, for view-related functionality.
extension Array where Element == Card {
    /// A text that is the concatenation of each card's colored text.
    var coloredText: Text {
         map{$0.coloredText}.concatenated()
    }
}
