//
//  AI.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/21/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A way to select an action in Hanabi.
///
/// Use AI instances (vs static), so they can have different perspectives.
protocol AI {
    /// The AI's name.
    var name: String { get }
    
    /// Summary of the AI.
    var description: String { get }
    
    /// Returns an action for the specified setup.
    mutating func action(for setup: Setup) -> Action
}
