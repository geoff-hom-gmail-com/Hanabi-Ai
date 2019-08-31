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
        VStack {
            Text("This is the About screen!")
//            Spacer()
            Divider()
            Text("Version \(AppInfo.version) (build \(AppInfo.build))")
        }
        .navigationBarTitle(Text("About"))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
