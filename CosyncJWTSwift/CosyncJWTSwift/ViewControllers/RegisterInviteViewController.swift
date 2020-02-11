//
//  RegisterInviteViewController.swift
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

class RegisterInviteViewController: UIViewController {

    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showRegisterInviteFailedAlert(){
        
        let alert = UIAlertController(title: "Register Invite Failed", message: "You have entered an invalid code.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        
        if  let handle = self.handle.text,
            let password = self.password.text,
            let code = self.code.text,
            code.count > 0 {
             
             // activate spinner here
             let spinner = UIActivityIndicatorView(style: .medium)
             spinner.startAnimating()
             
             CSRESTManager.shared.register(handle, password: password, code: code, onCompletion: { (err) in
                 
                 DispatchQueue.main.async {
                     
                     spinner.stopAnimating()
                     spinner.removeFromSuperview()
                     
                     if let error = err {
             
                         NSLog(error.localizedDescription)
                         self.showRegisterInviteFailedAlert()
                     } else {
                         
                         CSRESTManager.shared.getUser(onCompletion: { (err) in
                             
                             if let error = err {
                                 NSLog(error.localizedDescription)

                             } else {
                                 
                                 DispatchQueue.main.async {

                                     self.performSegue(withIdentifier: "registerSegue", sender: self)
                                     
                                 }
                                 
                             }
                             
                         })
         
                     }
                 }

             })
             
             // spinner style here
             spinner.center = self.view.center
             spinner.color = UIColor.gray;
             self.view.addSubview(spinner)
             
         } else {
             self.showRegisterInviteFailedAlert()
         }
    }
    
}
