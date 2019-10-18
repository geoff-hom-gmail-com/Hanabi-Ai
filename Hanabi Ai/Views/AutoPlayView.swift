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
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        Group {
            NumberOfPlayersStepper()
            DeckSetupPicker()
            // TODO: if Custom deck, then need ability to enter that
            // E.g., if Custom, show text field. pre-populate with ordered deck, then user can customize
            
            
            
//            NavigationLink(destination: OneGameView(numberOfPlayers: numberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)) {
//                Spacer()
//                Text("Go")
//            }
            NavigationLink( destination: OneGameView() ) {
                            Spacer()
                            Text("Go")
                        }
            NavigationLink( destination: OneGameView() ) {
                EmptyView()
            }
            Button(action: {
                // prep
                self.model.makeGame()
                // trigger navLink
                
            }) {
                // TODO: This doesn't have the ">" arrow like a NavLink has, but that's a UI issue we can deal with later if desired.
                HStack {
                    Spacer()
                    Text("Go")
                }
            }
        }
    }
}

/// A view that shows a stepper for selecting the number of players in a game.
struct NumberOfPlayersStepper: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        Stepper("Players: \(model.numberOfPlayers)", value: $model.numberOfPlayers, in: 2...5)
    }
}

/// A view that shows a picker for selecting the deck setup.
///
/// This may be used in other areas (e.g., MultipleGamesGroup), so keep it extracted.
struct DeckSetupPicker: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        // The label doesn't end with `":"`, because the picker's in a form.
        Picker("Deck Setup", selection: $model.deckSetup) {
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
//            NumberOfPlayersStepper(numberOfPlayers: $numberOfPlayers)
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

//struct AutoPlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AutoPlayView()
//        }
//    }
//}

// TODO: not sure if I like this. here, we give the preview a brand new model. But in the real app, this view would be using a model influenced by previous views. So for example, in OGV, the preview has just Model(). But in reality we'd have that Model have game already set from APV. I guess I need to modify this model. Hmm...
/// A preview provider that shows a preview of the auto-play view.
struct AutoPlayView_Previews: PreviewProvider {
    /// The model for this app.
    static var model = Model()
    
    static var previews: some View {
        NavigationView {
            AutoPlayView().environmentObject(model)
        }
    }
}
