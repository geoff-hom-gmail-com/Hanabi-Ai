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
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                NumberOfPlayersStepper()
                DeckSetupPicker()
                
                // Note: This results in a UITableView warning, even if showing only a text.
                if model.deckSetup == .custom {
                    CustomDeckTextField()
                }
                
                AIPicker()
            }
            
//            Section(header: Text("One Game")) {
            Section {
                OneGameGroup()
            }
//            Section(header: Text("Multiple Games")) {
            Section {
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
//    @EnvironmentObject var model: Model
    
    var body: some View {
        Group {
//            NumberOfPlayersStepper()
//            DeckSetupPicker()
//
            // Note: This results in a UITableView warning, even if showing only a text.
//            if model.deckSetup == .custom {
//                CustomDeckTextField()
//            }
            
//            AIPicker()
            
            // TODO: (As of Xcode 11.1) I wanted to have a button that will first call model.makeGame() and then trigger a navigation link programmatically, like with isActive or tag/selection. However, all navigation links I make result in a row that can be activated by pressing.
            // Tried .hidden(), EmptyView(), Text(""), .frame(width: 0, height: 0), Spacer(): The row is always pressable.
            // Instead, will use the navigation link below and call model.makeGame() in the destination's .onAppear().
            NavigationLink( destination: OneGameView() ) {
                Text("One Game")
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

/// A view that shows a picker for selecting the AI.
///
/// When Xcode 11.2 comes out, see if it fixes Picker bugs (see AIPicker.swift).
struct AIPicker: View {
    /// The model for this app.
    @EnvironmentObject var model: Model
    
    var body: some View {
        // The label doesn't end with `":"`, because the picker's in a form.
        Picker("AI", selection: $model.aiIndex) {
            ForEach(Model.AIs.indices) {
                Text(Model.AIs[$0].name)
            }
        }
    }
}

// MARK: MultipleGamesGroup

/// A view that shows controls for selecting how the computer will play multiple games against itself.
struct MultipleGamesGroup: View {
    var body: some View {
        Group {
            NumberOfGamesChooser()
            NavigationLink( destination: MultipleGamesView() ) {
                Spacer()
                Text("Go")
            }
        }
    }
}

/// A view that shows a text field for selecting the number of games.
///
/// TODO: TextField doesn't seem easy-to-use with numbers yet. So we'll use text for now and revisit later.
/// This works only with numbers. If text is entered, it'll probably just go to some default.
struct NumberOfGamesChooser: View {
    /// The model for this app.
    @EnvironmentObject var model: Model

    //TODO: User could enter something invalid. So we'll have to check. Could try a picker, like the decimal calorie entry in MFP.
    
    var body: some View {
        HStack {
            Text("Games:")
            // TODO: Get TextField working with Int.
//            TextField( "100", value: $model.numberOfGames, formatter: NumberFormatter() )
            TextField("100", text: $model.numberOfGamesString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
//        model.customDeckDescription = Deck.playFirstCardString
        return NavigationView {
            AutoPlayView().environmentObject(model)
        }
    }
}

