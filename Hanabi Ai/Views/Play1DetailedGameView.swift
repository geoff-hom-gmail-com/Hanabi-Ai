//
//  Play1DetailedGameView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct Play1DetailedGameView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Random Deck:")
                TextField("g1r2w3b4y5", text: /*@START_MENU_TOKEN@*/.constant("")/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: AboutView()) {
                    Text("Go")
                }
            }
            .padding(.vertical)
//            .background(Color.green)
//            Divider()
            VStack {
                Text("Specific:")
                TextField("g1r2w3b4y5", text: /*@START_MENU_TOKEN@*/.constant("")/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: AboutView()) {
                    Text("Go")
                }
            }
            .padding(.vertical)
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
