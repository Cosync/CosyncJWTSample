//
//  ForgotPasswordViewController.swift
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
//  Created by Cosync, Inc on 2/3/20.
//
    

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var handle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Pop-up login failed alert when users input incorrect email or password
    func forgotPasswordFailedAlert(){
        
        let alert = UIAlertController(title: "Forgot Password Failed", message: "You have entered an invalid handle.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        if  let handleText = self.handle?.text {
            
            if handleText.count == 0 {
                self.forgotPasswordFailedAlert()
            } else {

                // activate spinner here
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                
                CSRESTManager.shared.forgotPassword(handleText, onCompletion: { (err) in
                    
                    DispatchQueue.main.async {
                        
                        spinner.stopAnimating()
                        spinner.removeFromSuperview()
                        
                        if let error = err {
                
                            NSLog(error.localizedDescription)
                            self.forgotPasswordFailedAlert()
                        } else {
                            
                            self.performSegue(withIdentifier: "resetPasswordSegue", sender: self)
                            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ResetPasswordViewController
        {
            if let resetPasswordViewController = segue.destination as? ResetPasswordViewController {
                resetPasswordViewController.handle = self.handle?.text
            }
        }
    }
}


