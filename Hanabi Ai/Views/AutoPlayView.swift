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
            Section(header: Text("One Game")) {
                OneGameGroup()
            }
            Section(header: Text("Multiple Games")) {
                MultipleGamesGroup()
            }
        }
        .navigationBarTitle(Text("Auto-Play"), displayMode: .inline)
    }
}

// MARK: OneGameGroup

/// A view that shows controls for selecting how the computer will play one game against itself.
struct OneGameGroup: View {
    /// The number of players in the game.
    @State private var numberOfPlayers = 2
    
    /// The deck setup to use.
    @State private var deckSetup: DeckSetup = .random
    
//    @State private var deckSetupIndex: Int = 0

//    @State private var deckSetup2: DeckSetup2 = .random
//    @State private var deckSetup3: DeckSetup3 = .random

    /// The card order to use if the deck setup is "custom."
    ///
    /// This isn't implemented yet, but it should be a human-readable string, so one can test it manually.
    @State private var customDeckDescription: String = ""
    
    var body: some View {
        Group {
            NumberOfPlayersStepper(numberOfPlayers: $numberOfPlayers)
            //
//            Picker("Deck Setup3", selection: $deckSetup3) {
//                ForEach(DeckSetup3.allCases) {
//                    Text($0.name).tag($0)
//                }
//            }
            //works
//            Picker("Deck Setup2", selection: $deckSetup2) {
//                ForEach(DeckSetup2.allCases) {
//                    Text($0.name).tag($0)
//                }
//            }
            // doesn't work for custom?! ah, there's cross talk somewhere; OGV call
//            Picker("Deck Setup", selection: $deckSetup) {
//                ForEach(DeckSetup.allCases) {
//                    Text($0.name).tag($0)
//                }
//            }
           
            
            // so it's all my fault. what's the lesssons here?
            // if I had implemented custom decks, this might've been more clear. or maybe we wouldn't have found this "bug."
            // let's think about what to fix. We need to figure out how to not have a game made and dealt each time we change a freaking option. I know it's declarative code, but this is model stuff.
            
//            Picker("Deck Setup indices", selection: $deckSetupIndex) {
//                ForEach(DeckSetup.allCases.indices) {
//                    Text(DeckSetup.allCases[$0].name).tag($0)
//                }
//            }
            
            DeckSetupPicker(deckSetup: $deckSetup)
            // TODO: if Custom deck, then need ability to enter that
            // E.g., if Custom, show text field. pre-populate with ordered deck, then user can customize
//            NavigationLink(destination: OneGameView(numberOfPlayers: numberOfPlayers, deckSetup: DeckSetup.allCases[deckSetupIndex], customDeckDescription: customDeckDescription)) {
            NavigationLink(destination: OneGameView(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)) {
                
                Spacer()
                Text("Go")
            }
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
///
/// This may be used in other areas (e.g., MultipleGamesGroup), so keep it extracted.
struct DeckSetupPicker: View {
    /// The deck setup to use.
    @Binding var deckSetup: DeckSetup

    var body: some View {
        // The label doesn't end with `":"`, because the picker's in a form.
        Picker("Deck Setup", selection: $deckSetup) {
            ForEach(DeckSetup.allCases) {
                Text($0.name).tag($0)
            }
        }
    }
}

// MARK: MultipleGamesGroup

/// A view that shows controls for selecting how the computer will play multiple games against itself.
struct MultipleGamesGroup: View {
    /// The number of players in the game.
    @State private var numberOfPlayers = 2
    
    /// The number of games to play.
    @State private var numberOfGames = 101
    
    var body: some View {
        Group {
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
