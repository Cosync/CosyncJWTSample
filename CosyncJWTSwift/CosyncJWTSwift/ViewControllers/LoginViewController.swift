//
//  LoginViewController.swift
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
    

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!

    
    /* Standard functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
    }
    
    /* UITextFieldDelegate */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.emailTextInput {
            self.passwordTextInput?.becomeFirstResponder()
        } else if textField == self.passwordTextInput {
            login()
        }
        return false
    }
    
    /* Actions */
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func Login(_ sender: Any) {
        login()
    }
    
    @IBAction func SignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    @IBAction func Register(_ sender: Any) {
        
        self.performSegue(withIdentifier: "registerInviteSegue", sender: self)
    }
    /* Support Functions */
    
    //Pop-up login failed alert when users input incorrect email or password
    func showLoginFailedAlert(){
        
        let alert = UIAlertController(title: "Login Failed", message: "You have entered an invalid handle or password.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func login() {
        if  let emailText = self.emailTextInput?.text,
            let passwordText = self.passwordTextInput?.text {
            
            // activate spinner here
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            
            CSRealmManager.shared.login(emailText, password: passwordText, onCompletion: { (err) in
                
                DispatchQueue.main.async {
                    
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()
                    
                    if let error = err {
            
                        NSLog(error.localizedDescription)
                        self.showLoginFailedAlert()
                    } else {
                        
                        CSRESTManager.shared.getUser(onCompletion: { (err) in
                            
                            if let error = err {
                                NSLog(error.localizedDescription)
                                self.showLoginFailedAlert()
                            } else {
                                
                                DispatchQueue.main.async { self.performSegue(withIdentifier: "loginSegue", sender: self) }
                                
                            }
                            
                        })
                        
                        self.view.addSubview(spinner)
                        
                        
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
