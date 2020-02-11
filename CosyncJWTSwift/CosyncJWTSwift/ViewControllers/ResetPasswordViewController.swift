//
//  ResetPasswordViewController.swift
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

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var handle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Pop-up login failed alert when users input incorrect email or password
    func resetPasswordFailedAlert(){
        
        let alert = UIAlertController(title: "Reset Password Failed", message: "You have entered an invalid code or paasword.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func verifyCode(_ sender: Any) {
        
        if let handle = self.handle,
           let password = self.password.text,
           let code = self.code.text,
               code.count > 0 {

            // activate spinner here
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()

            CSRESTManager.shared.resetPassword(handle, password: password, code: code, onCompletion: { (err) in

                DispatchQueue.main.async {

                    spinner.stopAnimating()
                    spinner.removeFromSuperview()

                    if let error = err {

                        NSLog(error.localizedDescription)
                        self.resetPasswordFailedAlert()
                    } else {
                        
                        self.performSegue(withIdentifier: "resetPasswordSuccessSegue", sender: self)
                    }
                }

            })

            // spinner style here
            spinner.center = self.view.center
            spinner.color = UIColor.gray;
            self.view.addSubview(spinner)

        } else {
            self.resetPasswordFailedAlert()
        }
    }

}
