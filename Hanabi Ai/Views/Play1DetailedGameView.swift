//
//  Play1DetailedGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct Play1DetailedGameView: View {
//    @State private var deck: String = "this is a test yes its kjleflkef eit's really longlong"
    @State private var randomDeckDescription: String = Game.randomDeckDescription
    @State private var specificDeckDescription: String = ""

    var body: some View {
        // Using Form until .lineLimit(nil) starts working robustly.
        Form {
            Section {
                VStack {
                    Text("Random Deck:")
                    TextField("Deck contents: g3r2w3b1y5, etc.", text: $randomDeckDescription).font(.caption)
                    // .lineLimit(nil) not working. Can wrap in UITextField, but it should work. Waiting for Apple.
                    
                    // temp, until TextField.lineLimit(nil) works
                    Text(randomDeckDescription)
                        .font(.caption)
                        .lineLimit(nil)
                    
                    NavigationLink(destination: AboutView()) {
                        Text("Go")
                    }
                }
            }
//            .padding(.vertical)
            //            .background(Color.green)
            //            Divider()
            Section {
                VStack {
                    Text("Specific:")
                    TextField("Deck contents: g3r2w3b1y5, etc.", text: $specificDeckDescription)
                        .font(.caption)
                    // I could seed this with the random deck. Or more likely, the last specific deck. If none, use the random deck.
                    
                    NavigationLink(destination: AboutView()) {
                        Text("Go")
                    }
                }
//                .padding(.vertical)
            }
            //            .background(Color.blue)
        }
        .navigationBarTitle(Text("Play 1 Detailed Game"))
    }
}

struct Play1DetailedGameView_Previews: PreviewProvider {
    static var previews: some View {
        Play1DetailedGameView()
    }
}
