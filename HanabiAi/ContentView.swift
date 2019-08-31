//
//  ContentView.swift
//  HanabiAi
//
//  Created by Geoff Hom on 8/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//
//  Abstract:
//  TODO: rename to Home?
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // This isn't working so far (beta).
//        NavigationView {
//            NavigationLink(destination: About()) {
//                Text("About")
//            }
//            .navigationBarTitle(Text("Hanabi Ai"))
//        }
        
        NavigationView {
            VStack {
                NavigationLink(destination: About()) {
                    Text("About")
                }
                
            }
            .navigationBarTitle(Text("Hanabi Ai"))
        }
        
        // Nav UI. I don't like it as much.
//        NavigationView {
//            List {
//                NavigationLink(destination: About()) {
//                    Text("About")
//                }
//
//            }
//            .navigationBarTitle(Text("Hanabi Ai"))
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
