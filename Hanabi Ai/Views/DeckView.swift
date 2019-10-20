//
//  DeckView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/19/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

/// A view that shows a label and a deck.
///
/// The format is `label`, `": "` (which has a non-breaking space), and the deck.
struct DeckView: View {
    /// A string for labeling the deck.
    let label: String

    /// The deck.
    let deck: Deck

    /// Creates a deck view that shows the specified label and deck.
    ///
    /// Default label: `"Deck"`.
    init(deck: Deck, label: String = "Deck") {
        self.deck = deck
        self.label = label
    }

    var body: some View {
        Text("\(label): ") + deck.coloredText
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(deck: Game().startingDeck, label: "Test")
            .font(.caption)
    }
}
