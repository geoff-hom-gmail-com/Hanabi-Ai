//
//  AutoPlayView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct AutoPlayView: View {
    var body: some View {
        Form {
            OneGameSection()
            MultipleGamesSection()
        }
        .navigationBarTitle(Text("Auto-Play"), displayMode: .inline)
    }
}

struct OneGameSection: View {
    @State private var numberOfPlayers: Int = 2
    @State private var deckSetup: DeckSetup = .random
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

struct MultipleGamesSection: View {
    @State private var numberOfPlayers: Int = 2
    @State private var numberOfGames: Int = 101
    var body: some View {
        Section(header: Text("Multiple Games")) {
            NumberOfPlayersStepper(numberOfPlayers: $numberOfPlayers)
            NumberOfGamesHStack(numberOfGames: $numberOfGames)
            PlayMultipleGamesNavigationLink()
        }
    }
}

// Select number of players.
struct NumberOfPlayersStepper: View {
    @Binding var numberOfPlayers: Int
    var body: some View {
        Stepper("Players: \(numberOfPlayers)", value: $numberOfPlayers, in: 2...5)
    }
}

// Select deck setup.
struct DeckSetupPicker: View {
    @Binding var deckSetupSelection: DeckSetup
    var body: some View {
        // No ":" after label because Picker's in a Form.
        Picker("Deck Setup", selection: $deckSetupSelection) {
            ForEach(DeckSetup.allCases) { deckSetup in
                Text(deckSetup.name).tag(deckSetup)
            }
        }
    }
}

// Play a game. Show results.
struct PlayGameNavigationLink: View {
    var numberOfPlayers: Int
    var deckSetup: DeckSetup
    var customDeckDescription: String
    var body: some View {
        NavigationLink(destination: GameResultsView(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)) {
            Spacer()
            Text("Go")
        }
    }
}

// Select number of games.
struct NumberOfGamesHStack: View {
    @Binding var numberOfGames: Int
    @State private var numberOfGamesString: String = "300"
    //TODO: When user enters new number of games, update the binding. Hmm, user could enter something invalid. So we'll have to check.
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

// Play multiple games in a row. Show results.
struct PlayMultipleGamesNavigationLink: View {
    var body: some View {
        // TODO: This would be a new view for showing multiple game results.
        NavigationLink(destination: Text("Placeholder")) {
            Spacer()
            Text("Run")
        }
    }
}

struct AutoPlayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AutoPlayView()
        }
    }
}
