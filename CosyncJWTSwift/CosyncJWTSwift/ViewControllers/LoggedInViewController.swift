//
//  LoggedInViewController.swift
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
//  Created by Cosync, Inc on 1/27/20.
//
    

import UIKit

class LoggedInViewController: UIViewController {

    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var inviteHandle: UITextField!
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

    }
    
    @IBAction func logout(_ sender: Any) {
        CSRealmManager.shared.logout()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showInviteNotSupported(){
        
        let alert = UIAlertController(title: "Invite Not Support", message: "Your applications does not support invitations.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    func showInviteFailedAlert(){
        
        let alert = UIAlertController(title: "Invite Failed", message: "You have entered an invalid invite handle.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showInviteDataFailedAlert(){
        
        let alert = UIAlertController(title: "Invite Failed", message: "You have entered an invalid JSON invite data.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func invite(_ sender: Any) {
        
        if  let handleText = self.inviteHandle?.text {
            
            if handleText.count == 0 {
                self.showInviteFailedAlert()
            } else {
                
                if self.checkInviteData() {
                    let inviteData = self.getInviteData()
                    
                    // activate spinner here
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    
                    CSRESTManager.shared.invite(handleText, inviteData: inviteData, onCompletion: { (err) in
                        
                        DispatchQueue.main.async {
                            
                            spinner.stopAnimating()
                            spinner.removeFromSuperview()
                            
                            if let error = err {
                    
                                NSLog(error.localizedDescription)
                                self.showInviteNotSupported()
                            } else {
                                
                                self.performSegue(withIdentifier: "inviteSegue", sender: self)
                                
                            }
                        }
                        

                    })
                    
                    // spinner style here
                    spinner.center = self.view.center
                    spinner.color = UIColor.gray;
                    self.view.addSubview(spinner)
                } else {
                    self.showInviteDataFailedAlert()
                }
            }
        }
    }
    
    func getInviteData() -> String? {
        if let inviteData = self.inviteData.text,
            inviteData.count > 0 {
            return inviteData
        } else {
            return nil
        }
    }
    
    func checkInviteData() -> Bool {
        
        if  let inviteDataString = self.inviteData.text,
            inviteDataString.count > 0,
            let inviteData = inviteDataString.data(using: .utf8) {
            
            guard let _ = (try? JSONSerialization.jsonObject(with: inviteData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                return false
            }
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is InviteViewController
        {
            if let inviteViewController = segue.destination as? InviteViewController {
                inviteViewController.inviteHandle = self.inviteHandle.text
            }
        }
    }
}
