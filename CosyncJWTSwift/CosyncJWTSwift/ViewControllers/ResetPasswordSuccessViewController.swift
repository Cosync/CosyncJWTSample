//
//  ResetPasswordSuccessViewController.swift
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
//  Created by Cosync, Inc on 2/4/20.
//
    

import UIKit

class ResetPasswordSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        if  let viewControllers = self.navigationController?.viewControllers {
            let index = viewControllers.count - 3
            
            if let tabBar = self.navigationController?.parent as? UITabBarController {
                tabBar.selectedIndex = 0
            }

            self.navigationController?.popToViewController(viewControllers[index], animated: true)
        }
    }
    

}
