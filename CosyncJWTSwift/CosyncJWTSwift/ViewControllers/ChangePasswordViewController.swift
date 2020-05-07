//
//  ChangePasswordViewController.swift
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
//  Created by Cosync, Inc on 2/11/20.
//
    

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showChangePasswordFailedAlert(_ error: Error?){
        
        var message = "You have entered an invalid password."
        
        if let errorRest = error as? CSRESTManager.CSRESTError,
               errorRest == .invalidPassword {
            message = "your new password is not secure"
        }
        
        let alert = UIAlertController(title: "Change Password Failed", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func changePassword(_ sender: Any) {
        
        if  let newPasswordText = self.newPassword?.text,
            let passwordText = self.password?.text {
            
            if newPasswordText.count == 0 || passwordText.count == 0 {
                self.showChangePasswordFailedAlert(nil)
            } else {
                
                // activate spinner here
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                
                CSRESTManager.shared.changePassword(newPasswordText, password: passwordText, onCompletion: { (err) in
                    
                    DispatchQueue.main.async {
                        
                        spinner.stopAnimating()
                        spinner.removeFromSuperview()
                        
                        if err != nil {
                
                            self.showChangePasswordFailedAlert(err)
                        } else {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                    

                })
                
                // spinner style here
                spinner.center = self.view.center
                spinner.color = UIColor.gray;
                self.view.addSubview(spinner)

            }
        }
        
        
    }
}
