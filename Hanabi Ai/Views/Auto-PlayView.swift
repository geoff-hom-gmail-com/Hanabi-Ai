//
//  Auto-PlayView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct Auto_PlayView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Play")
                TextField("100", text: /*@START_MENU_TOKEN@*/.constant("")/*@END_MENU_TOKEN@*/)
                Text("Games:")
                NavigationLink(destination: AboutView()) {
                    Text("Go")
                }
            }
            .padding()
            NavigationLink(destination: Play1DetailedGameView()) {
                Text("Play 1 Detailed Game")
            }
            .padding()
        }
        .navigationBarTitle(Text("Auto-Play"))    
    }
}

struct Auto_PlayView_Previews: PreviewProvider {
    static var previews: some View {
        Auto_PlayView()
    }
}
