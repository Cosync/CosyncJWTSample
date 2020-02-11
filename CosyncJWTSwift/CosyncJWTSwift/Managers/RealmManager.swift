//
//  RealmManager.swift
//  COSYNC SWIFT SDK
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//  Created by Cosync, Inc on 1/24/20.
//
    
import Foundation
import RealmSwift

class CSRealmManager {
    
    static let shared = CSRealmManager()
            
    private init() {
    }
    
    deinit {
    }
    
    func login(_ handle: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        CSRESTManager.shared.login(handle, password: password, onCompletion: { (err) in
            if let err = err {
                completion(err)
            } else {
                NSLog("Login Success")
                
                let authURL = Constants.AUTH_URL
                
                if let jwt = CSRESTManager.shared.jwt {
                    let creds = SyncCredentials.jwt(jwt)
                    SyncUser.logIn(with: creds, server: authURL, onCompletion: { (user, err) in
                        if let _ = user {

                        }
                        completion(err)
                    })
                }

            }
        })
    }
    
    func logout() {
        CSRESTManager.shared.logout()
    }

}
