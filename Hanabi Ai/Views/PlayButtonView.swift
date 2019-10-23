//
//  PlayButtonView.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/23/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

/// A  view that shows a button that plays something.
struct PlayButtonView: View {
    /// A function that plays something.
    let playFunction: () -> Void
    
    var body: some View {
        // The spacers are to center the button.
        HStack {
            Spacer()
            Button(action: playFunction) {
                Text("Play")
            }
            Spacer()
        }
    }
}


//struct PlayButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayButtonView()
//    }
//}
