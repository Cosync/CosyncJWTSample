//
//  AppState.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation

// View table used for routing. Updated when a new view is added
enum TargetUI: Int {
    case none
    case loggedOut
    case loggedIn
    case password
}

// Alert message container
struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let target: TargetUI
    let state: AppState
}

// Global state observable used to trigger routing
class AppState: ObservableObject {
    @Published var target: TargetUI = .loggedOut
    var context: Any = ""
}
