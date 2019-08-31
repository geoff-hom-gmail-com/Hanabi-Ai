//
//  AboutView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        // Using Form until Text.lineLimit(nil) starts working robustly.
        Form {
            Section {
                Text("Hanabi Ai is a simulator for the card game Hanabi.")
            }
            
            VStack(alignment: .leading) {
                Text("Use Hanabi Ai to:")
                Text("• Auto-play many games in a row.")
                Text("• Auto-play a specific game (i.e., deck setup).")
            }
            
            VStack(alignment: .leading) {
                Text("Notes:")
                Text("• Only 2-player games for now.")
                Text("• Only 1 AI personality offered:")
                Text("      • Superman: Has X-ray vision, so knows all cards, including the deck.")
                Text("• % wins: TBD (1 in X)")
                Text("• Losing-deck example: TBD")
            }
            
            Section {
                Text("Version \(AppInfo.version) (build \(AppInfo.build))")
            }
        }
        .navigationBarTitle(Text("About"))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
