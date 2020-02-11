//
//  ApplicationViewController.swift
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
//  Created by Cosync, Inc on 2/7/20.
//
    

import UIKit

class ApplicationViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var appDataLabel: UILabel!
    @IBOutlet weak var appData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.isHidden = true
        appDataLabel.isHidden = true
        appData.isHidden = true
        
        appData.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        appData.layer.borderWidth = 1.0
        appData.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshAppData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        refreshAppData()
    }
    
    func showSetAppDataSuccess(){
        
        let alert = UIAlertController(title: "Set Application Data Success", message: "The application data was set", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAppDataFailedAlert(){
        
        let alert = UIAlertController(title: "Set Application Data Failed", message: "You have entered an invalid JSON application data.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setApplicationData(_ sender: Any) {

        if  self.checkAppData(),
            let appData = self.getAppData() {
            
            
            // activate spinner here
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            
            CSRESTManager.shared.setAppData( appData, onCompletion: { (err) in
                
                DispatchQueue.main.async {
                    
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()
                    
                    if let error = err {
            
                        NSLog(error.localizedDescription)
                        self.showAppDataFailedAlert()
                    } else {
                        
                        self.showSetAppDataSuccess()
                        
                    }
                }

            })
            
            // spinner style here
            spinner.center = self.view.center
            spinner.color = UIColor.gray;
            self.view.addSubview(spinner)
        } else {
            self.showAppDataFailedAlert()
        }

    }
    
    func refreshAppData() {
        
        CSRESTManager.shared.getApplication(onCompletion: { (err) in
            
            if let error = err {
                NSLog(error.localizedDescription)
            } else {
                
                DispatchQueue.main.async {
                    
                    if let appName = CSRESTManager.shared.appName {
                        self.name.text = appName
                        self.name.isHidden = false
                    }
                    
                    if let appData = CSRESTManager.shared.appData {
                        self.appDataLabel.isHidden = false
                        
                        let prettyJsonData = try! JSONSerialization.data(withJSONObject: appData, options: .prettyPrinted)
                        let jsonString = String(decoding: prettyJsonData, as: UTF8.self)
                        self.appData.text = jsonString
                        self.appData.isHidden = false
                    }
                }
                
            }
            
        })
    }
    
    func getAppData() -> String? {
        if let appData = self.appData.text,
            appData.count > 0 {
            return appData
        } else {
            return nil
        }
    }
    
    func checkAppData() -> Bool {
        
        if  let appDataString = self.appData.text,
            appDataString.count > 0,
            let appData = appDataString.data(using: .utf8) {
            
            guard let _ = (try? JSONSerialization.jsonObject(with: appData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                return false
            }
            return true
        }
        return true
    }
}
