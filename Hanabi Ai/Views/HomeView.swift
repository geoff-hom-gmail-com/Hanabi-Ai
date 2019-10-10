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

/// A `View` that shows the main menu.
struct HomeView: View {
    var body: some View {
        NavigationView {
            //TODO: Update UI so options are easier to see. List? Form?
            VStack {
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                .padding()
                NavigationLink(destination: AutoPlayView()) {
                    Text("Auto-Play")
                }
                .padding()
            }
            .navigationBarTitle(Text("Hanabi Ai"))
        }
    }
}

// MARK: Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
