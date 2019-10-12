//
//  AboutView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/31/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

/// A view that shows info about this app.
///
/// If a newbie runs this app, this view should bring them up to speed. Set appropriate expectations of what the app can/can't do. (Don't promise upcoming features because my track record is poor.) Also provides app version/build, for debugging.
struct AboutView: View {
    var body: some View {
        // Using Form until Text.lineLimit(nil) starts working robustly. (A grouped List makes more sense that Form.)
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
                // TODO: this is the % wins for the AI
                // add average score
                Text("      • Win %: TBD (1 in X)")
                // TODO: move elsewhere?
                Text("• Losing-deck example: TBD")
            }
            
            Section {
                Text("Version \(AppInfo.version) (build \(AppInfo.build))")
            }
        }
        .navigationBarTitle(Text("About"), displayMode: .inline)
    }
}

// MARK: Previews

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
