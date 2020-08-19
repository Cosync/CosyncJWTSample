//
//  AlertExtension.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import SwiftUI

// Alert modal helper

extension Alert {
    
    init(_ message: AlertMessage) {
        self.init(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("OK"), action: {
                if (message.target != .none) {
                    message.state.target = message.target
                }
                return;
            })
        )
    }
}
