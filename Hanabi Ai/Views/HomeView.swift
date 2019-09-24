//
//  HomeView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//
//  Abstract:
//  Home/main menu.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                .padding()
                NavigationLink(destination: Auto_PlayView()) {
                    Text("Auto-Play")
                }
                .padding()
            }
            .navigationBarTitle(Text("Hanabi Ai"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
