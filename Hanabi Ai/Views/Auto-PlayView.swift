//
//  Auto-PlayView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct Auto_PlayView: View {
    @State private var oneGameNumberOfPlayers: Int = 2
    @State private var multipleGamesNumberOfPlayers: Int = 2
    @State private var numberOfGamesString: String = "101"
    @State private var deckSetup: DeckSetup = .random
    @State private var customDeckDescription: String = ""


    // Hmm, either we get passed a game when we start this view, which doesn't make sense... or this view creates an empty game.
//    var game: Game
    var body: some View {
        Form {
            // TODO: Can extract this section and pull state down here
            Section(header: Text("One Game")) {
                NumberOfPlayersStepper(numberOfPlayers: $oneGameNumberOfPlayers)
                Picker(selection: $deckSetup, label: Text("Deck")) {
                    Text("Random").tag(DeckSetup.random)
                    // TODO: later, could have options like "hard," "easy"; will have to figure out how to make those
                    Text("Custom").tag(DeckSetup.custom)
                }
                // TODO: if Custom deck, then need ability to enter that
                // E.g., if Custom, show text field. pre-populate with ordered deck, then user can customize
                
                // how do we pass data to the destination? I guess beforehand, we need the object to pass in. We can't make it in the destination call.
                // or, I pass the view the info it needs to make the Game object itself
                // it needs the number of players, type of deckSetup, and if custom, the specific deck order.
                NavigationLink(destination: GameResultsView(numberOfPlayers: oneGameNumberOfPlayers, deckSetup: deckSetup, customDeckDescription: customDeckDescription)) {
                    Spacer()
                    Text("Go")
                }
            }
            Section(header: Text("Multiple Games")) {
                NumberOfPlayersStepper(numberOfPlayers: $multipleGamesNumberOfPlayers)
                // TODO: Align Text and TextField. May want a custom TextField VerticalAlignment, as in WWDC talk on custom views in SwiftUI. But someone else will probably work on this issue soon.
                HStack(alignment: .lastTextBaseline) {
                    Text("Number of games:").background(Color.gray.opacity(0.2))
                    TextField("Enter number of games", text: $numberOfGamesString).background(Color.gray.opacity(0.2))
                }
                // This would be a new view for showing multiple game results.
                NavigationLink(destination: AboutView()) {
                    Spacer()
                    Text("Go")
                }
            }
        }
        .navigationBarTitle(Text("Auto-Play"), displayMode: .inline)
    }
}

struct NumberOfPlayersStepper: View {
    @Binding var numberOfPlayers: Int
    var body: some View {
        Stepper("Players: \(numberOfPlayers)", value: $numberOfPlayers, in: 2...5)
    }
}

struct Auto_PlayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Auto_PlayView()
        }
    }
}

