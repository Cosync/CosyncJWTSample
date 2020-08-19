//
//  UserManager.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/12/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation


class UserManager {
    
    static let shared = UserManager()
            
    // user meta data
    var firstName : String = ""
    var lastName : String = ""
    var handle : String = ""

    private init() {
    }
    
    deinit {
    }
    
    func login(email: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        RESTManager.shared.login(email, password: password, onCompletion: { (error) in
                
            DispatchQueue.main.async {
                if error == nil {
                    RealmManager.shared.login(RESTManager.shared.jwt!, onCompletion: { (error) in
                         
                        DispatchQueue.main.async {
                            if error == nil {
                                RESTManager.shared.getUser(onCompletion: { (error) in
                                    if error == nil {
                                        if let metaData = RESTManager.shared.metaData {
                                            if let userData = metaData["user_data"] as? [String:Any] {
                                                if let name = userData["name"] as? [String:Any] {
                                                    if let firstName = name["first"] as? String {
                                                        self.firstName = firstName
                                                    }
                                                    if let lastName = name["last"] as? String {
                                                        self.lastName = lastName
                                                    }
                                                }
                                            }
                                        }
                                        if let handle = RESTManager.shared.handle {
                                            self.handle = handle
                                        }
                                        completion(nil)
                                    } else {
                                        completion(error)
                                    }
                                })
                                
                            } else {
                                completion(error)
                            }
                        }
                    })
                } else {
                    completion(error)
                }
            }
        })

        
    }
    
    func logout(onCompletion completion: @escaping (Error?) -> Void) {
        
        self.firstName = ""
        self.lastName = ""
        self.handle = ""
        RESTManager.shared.logout()
        RealmManager.shared.logout(onCompletion: { (error) in
            completion(error)
        })
    }
    
}
