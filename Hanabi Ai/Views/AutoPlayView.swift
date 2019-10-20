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
            
            // Note: This results in a UITableView warning, even if showing only a text.
            if model.deckSetup == .custom {
                CustomDeckTextField()
            }
            
            // TODO: (As of Xcode 11.1) I wanted to have a button that will first call model.makeGame() and then trigger a navigation link programmatically, like with isActive or tag/selection. However, all navigation links I make result in a row that can be activated by pressing.
            // Tried .hidden(), EmptyView(), Text(""), .frame(width: 0, height: 0), Spacer(): The row is always pressable.
            // Instead, will use the navigation link below and call model.makeGame() in the destination's .onAppear().
            NavigationLink( destination: OneGameView() ) {
                Spacer()
                Text("Go")
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

/// A view that shows a text field for entering a custom deck.
///
/// The text field initially shows the model's default custom deck.
struct CustomDeckTextField: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                Text("Custom deck: ")
                TextField("", text: $model.customDeckDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(nil)
            }.font(.caption)
            
            // This is temporary until `TextField()` works with `.lineLimit(nil)`.
            (Text("Custom deck: ")
                + Text(model.customDeckDescription))
                .font(.caption)
        }
    }
}

// MARK: MultipleGamesGroup

// TODO: This all needs to be updated to use
//     @EnvironmentObject var model: Model
// When I'm ready to actually play multiple games.

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

/// A preview of the auto-play view.
struct AutoPlayView_Previews: PreviewProvider {
    /// The model for this app.
    static var model = Model()
    
    static var previews: some View {
//        model.deckSetup = .custom
        model.customDeckDescription = Deck.playFirstCardString
        return NavigationView {
            AutoPlayView().environmentObject(model)
        }
    }
}

