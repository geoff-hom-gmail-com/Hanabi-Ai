//
//  AIPicker.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/21/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import SwiftUI

// TODO: Can't make abstract PickerView. For some reason, passing a binding into the view doesn't seem to work (e.g., picker2). Maybe this is fixed in Xcode 11.2? Will wait for the release, then try again. In the meantime, any view that wants a PickerView will just roll its own.

/// A view that shows a picker for selecting an AI.
//struct AIPicker: View {
//    /// The model for this app.
////    @EnvironmentObject var model: Model
//
//    /// The selected index.
//    @Binding var index: Int
//
//    var body: some View {
//        // The label doesn't end with `":"`, because the picker's in a form.
//        Picker("AI", selection: $index) {
//            ForEach(Model.AIs.indices) {
//                Text(Model.AIs[$0].name)
//            }
//        }
//    }
//}

// doesn't bind
/// A view that shows a picker for selecting an AI.
struct AIPicker2: View {
    let stuff = ["mild", "medium"]
    
    /// The selected index.
    @Binding var index2: Int

    var body: some View {
        Picker("AI", selection: $index2) {
            ForEach(stuff.indices) {
                Text(self.stuff[$0])
            }
        }
    }
}

// works
/// A view that shows a picker for selecting an AI.
struct AIPicker3: View {
    let stuff = ["mild", "medium"]
    
    @State private var index = 0
    
    var body: some View {
        Picker("AI", selection: $index) {
            ForEach(stuff.indices) {
                Text(self.stuff[$0])
            }
        }
    }
}
//
//struct AIPicker4: View {
//   var colors = ["Red", "Green", "Blue", "Tartan"]
//   @State private var selectedColor = 0
//
//   var body: some View {
//      VStack {
//         Picker(selection: $selectedColor, label: Text("Please choose a color")) {
//            ForEach(0 ..< colors.count) {
//               Text(self.colors[$0])
//            }
//         }
//         Text("You selected: \(colors[selectedColor])")
//      }
//   }
//}

struct AIPicker_Previews: PreviewProvider {
//    @State static private var aiIndex = 0
    @State static var index2 = 1

    static var previews: some View {
        NavigationView {
            Form {
//                AIPicker(index: $aiIndex)
                // this binding doesn't work (doesn't update). Why?
                AIPicker2(index2: $index2)
                AIPicker3()
//                AIPicker4()
            }
        }
    }
}
