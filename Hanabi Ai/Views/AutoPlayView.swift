//
//  AutoPlayView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

/// A view that shows controls for selecting how the computer will play itself.
struct AutoPlayView: View {
    var body: some View {
        Form {
            OneGameSection()
            MultipleGamesSection()
        }
        .navigationBarTitle(Text("Auto-Play"), displayMode: .inline)
    }
}

// MARK: OneGameSection

// TODO: maybe we should have the section above, and then we can group the contents and extract the group. That makes more sense in terms of code reuse.
/// A view that shows a section for selecting how the computer will play one game against itself.
struct OneGameSection: View {
    /// The number of players in the game.
    @State private var numberOfPlayers = 2
    
    /// The deck setup to use.
    @State private var deckSetup: DeckSetup = .random
    
    /// The card order to use if the deck setup is "custom."
    ///
    /// This isn't implemented yet, but it should be a human-readable string, so one can test it manually.
    @State private var customDeckDescription: String = ""
    
    var body: some View {
        Section(header: Text("One Game")) {
            NumberOfPlayersStepper(numberOfPlayers: $numberOfPlayers)
            DeckSetupPicker(deckSetupSelection: $deckSetup)
            // TODO: if Custom deck, then need ability to enter that
            // E.g., if Custom, show text field. pre-populate with ordered deck, then user can customize
            PlayGameNavigationLink(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)
        }
    }
}

/// A view that shows a stepper for selecting the number of players in a game.
struct NumberOfPlayersStepper: View {
    /// The number of players in the game.
    @Binding var numberOfPlayers: Int
    
    var body: some View {
        Stepper("Players: \(numberOfPlayers)", value: $numberOfPlayers, in: 2...5)
    }
}

/// A view that shows a picker for selecting the deck setup.
struct DeckSetupPicker: View {
    /// The deck setup to use.
    @Binding var deckSetupSelection: DeckSetup
    
    var body: some View {
        // We don't add ":" at the end of the label, because the picker's in a form.
        Picker("Deck Setup", selection: $deckSetupSelection) {
            ForEach(DeckSetup.allCases) {
                Text($0.name).tag($0)
            }
        }
    }
}

// TODO: unextract this? Extractions for single calls seems silly. Though we do that with Section above...
/// A view that shows a navigation link that goes to a screen for playing one game.
struct PlayGameNavigationLink: View {
    /// The number of players in the game.
    var numberOfPlayers: Int
    
    /// The deck setup to use.
    var deckSetup: DeckSetup
    
    /// The card order to use if the deck setup is "custom."
    var customDeckDescription: String
    
    var body: some View {
        NavigationLink(destination: OneGameView(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)) {
            Spacer()
            Text("Go")
        }
    }
}

// MARK: MultipleGamesSection

/// A `Section` that lets the user set up and play multiple games in a row.
struct MultipleGamesSection: View {
    /// The number of players in the game.
    @State private var numberOfPlayers = 2
    
    /// The number of games to play.
    @State private var numberOfGames = 101
    
    var body: some View {
        Section(header: Text("Multiple Games")) {
            NumberOfPlayersStepper(numberOfPlayers: $numberOfPlayers)
            NumberOfGamesChooser(numberOfGames: $numberOfGames)
            PlayMultipleGamesNavigationLink()
        }
    }
}

/// A `View` that lets the user choose the number of games to play.
struct NumberOfGamesChooser: View {
    /// The number of games to play.
    @Binding var numberOfGames: Int
    
    /// TODO: document
    @State private var numberOfGamesString: String = "300"
    
    //TODO: When user enters new number of games, update the binding. Hmm, user could enter something invalid. So we'll have to check. Could try a picker, like the decimal calorie entry in MFP.
    /// TODO: Document
    init(numberOfGames: Binding<Int>) {
        self._numberOfGames = numberOfGames
//        self.numberOfGamesString = "\(self.numberOfGames)"
    }
    
    var body: some View {
        HStack {
            // TODO: Align Text and TextField. May want a custom TextField VerticalAlignment, as in WWDC talk on custom views in SwiftUI. But someone else will probably work on this issue soon. After fixing alignment, remove background colors.
            Text("Number of games:").background(Color.gray.opacity(0.2))
            //TODO: what does textfieldstyle do? would one be more appropriate?
            //TODO: can I tell the texstfield to take in only numbers, and no decimal? e.g., positive integers? textcontent just has stuff like "zip code," etc.
            // Formatter, as in https://stackoverflow.com/questions/56958974/swiftui-textfield-binding-to-double-not-working-with-custom-formatter? Note there's a bug in Xcode 11 GM so it's not working as of that.
            TextField("Enter number of games", text: $numberOfGamesString).background(Color.gray.opacity(0.2))
        }
    }
}

/// A `NavigationLink` that goes to another screen to play multiple games in a row.
///
/// TODO: Do the games start right away? Or show setup first?
struct PlayMultipleGamesNavigationLink: View {
    var body: some View {
        // TODO: This would be a new view for showing multiple game results.
        NavigationLink(destination: Text("Placeholder")) {
            Spacer()
            Text("Run")
        }
    }
}

// MARK: Previews

struct AutoPlayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AutoPlayView()
        }
    }
}
