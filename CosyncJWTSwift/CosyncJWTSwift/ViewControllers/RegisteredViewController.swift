//
//  RegisteredViewController.swift
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
//  Created by Cosync, Inc on 2/10/20.
//
    

import UIKit

class RegisteredViewController: UIViewController {

    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var inviteDataLabel: UILabel!
    @IBOutlet weak var inviteData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let handle = CSRESTManager.shared.handle {
            self.handle.text = handle
        }
        
        if let uid = CSRESTManager.shared.uid {
            self.uid.text = uid
        }
        
        inviteData.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        inviteData.layer.borderWidth = 1.0
        inviteData.layer.cornerRadius = 5
        
        inviteDataLabel.isHidden = true
        inviteData.isHidden = true
        
        if  let json = CSRESTManager.shared.onboardingData {
            let prettyJsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let jsonString = String(decoding: prettyJsonData, as: UTF8.self)
            inviteData.text = jsonString
            inviteDataLabel.isHidden = false
            inviteData.isHidden = false
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        CSRealmManager.shared.logout()
        
        if  let viewControllers = self.navigationController?.viewControllers {
            let index = viewControllers.count - 3
            
            self.navigationController?.popToViewController(viewControllers[index], animated: true)
        }
    }
    
}
