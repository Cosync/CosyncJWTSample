//
//  ContentView.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {

        Group {
            if self.appState.target == .loggedOut {
                LoggedOutView()
            } else if self.appState.target == .loggedIn {
                LoggedInView()
            } else {
                PasswordView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
