//
//  UserDefaultsManager.swift
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

class CSUserDefaultsManager {
    
    private var defaults: UserDefaults
    
    static let shared = CSUserDefaultsManager()
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func object(forKey key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    func string(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    func integer(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    
    func bool(forKey key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    
    func set<T>(_ object: T, forKey key: String) {
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }
    
    func removeObject(forKey key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    func clear() {
        
        guard let appDomain = Bundle.main.bundleIdentifier else {
            return
        }
        
        defaults.removePersistentDomain(forName: appDomain)
        defaults.synchronize()
        
    }
    
}

