//
//  RealmManager.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/10/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
            
    var app : RealmApp! = nil

    private init() {
        self.app = RealmApp(id: Constants.REALM_APP_ID)
    }
    
    deinit {
    }
    
    func login(_ jwt: String, onCompletion completion: @escaping (Error?) -> Void) {

        app.login(withCredential: AppCredentials(jwt: jwt)) { (user, error) in
            
            guard error == nil else {
                completion(RESTError.internalServerError)
                return
            }
            
            completion(nil)
        }
        
    }
    
    func logout(onCompletion completion: @escaping (Error?) -> Void) {
        
        app.logOut(completion: { (error) in
            
            guard error == nil else {
                completion(RESTError.internalServerError)
                return
            }
            
            completion(nil)
        })
    }
    
}
