//
//  SignupViewController.swift
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
//  Created by Cosync, Inc on 1/30/20.
//
    

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signupData.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        signupData.layer.borderWidth = 1.0
        signupData.layer.cornerRadius = 5
    }
    
    //Pop-up login failed alert when users input incorrect email or password
    func showSignupFailedAlert(){
        
        let alert = UIAlertController(title: "Signup Failed", message: "You have entered an invalid handle or password.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSignupDataFailedAlert(){
        
        let alert = UIAlertController(title: "Signup Failed", message: "You have entered an invalid JSON signup data.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signup(_ sender: Any) {
        
        if  let handleText = self.handle?.text,
            let passwordText = self.password?.text {
            
            if handleText.count == 0 || passwordText.count == 0 {
                self.showSignupFailedAlert()
            } else {
                
                if self.checkSingupData() {
                    let signupData = self.getSingupData()
                    
                    // activate spinner here
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    
                    CSRESTManager.shared.signup(handleText, password: passwordText, signupData: signupData, onCompletion: { (err) in
                        
                        DispatchQueue.main.async {
                            
                            spinner.stopAnimating()
                            spinner.removeFromSuperview()
                            
                            if let error = err {
                    
                                NSLog(error.localizedDescription)
                                self.showSignupFailedAlert()
                            } else {
                                
                                self.performSegue(withIdentifier: "signupVerifySegue", sender: self)
                                
                            }
                        }
                        

                    })
                    
                    // spinner style here
                    spinner.center = self.view.center
                    spinner.color = UIColor.gray;
                    self.view.addSubview(spinner)
                } else {
                    self.showSignupDataFailedAlert()
                }
            }
        }
    }
    
    func getSingupData() -> String? {
        if let signupData = self.signupData.text,
            signupData.count > 0 {
            return signupData
        } else {
            return nil
        }
    }
    
    func checkSingupData() -> Bool {
        
        if  let signupDataString = self.signupData.text,
            signupDataString.count > 0,
            let signupData = signupDataString.data(using: .utf8) {
            
            guard let _ = (try? JSONSerialization.jsonObject(with: signupData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                return false
            }
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SignupVerifyViewController
        {
            if let signupVerifyViewController = segue.destination as? SignupVerifyViewController {
                signupVerifyViewController.handle = self.handle?.text
            }
        }
    }

}
