//
//  RESTManager.swift
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
    

import Foundation
import CryptoSwift

class CSRESTManager {
    
    // Login credentials
    var jwt: String?
    var accessToken: String?
    
    // complete signup credentials
    var signedUserToken: String?
    
    // Logged in user information
    var uid: String?
    var handle: String?
    var isAdmin: Bool?
    var onboardingData: [String:Any]?
    var lastLogin: Date?
    
    // application data
    var appName: String?
    var appData: [String:Any]?
    
    enum CSRESTError: Error {
        case invalidAppToken
        case appNoLongerExist
        case missingParameter
        case invalidAccessToken
        case internalServerError
        case invalidLoginCredentials
        case userAlreadyRegistered
        case invalidData
        case emailDoesNotExist
    }
    
    static let loginPath = "api/appuser/login"
    static let signupPath = "api/appuser/signup"
    static let completeSignupPath = "api/appuser/completeSignup"
    static let getUserPath = "api/appuser/getUser"
    static let forgotPasswordPath = "api/appuser/forgotPassword"
    static let resetPasswordPath = "api/appuser/resetPassword"
    static let changePasswordPath = "api/appuser/changePassword"
    static let getApplicationPath = "api/appuser/getApplication"
    static let setAppDataPath = "api/appuser/setAppData"
    static let invitePath = "api/appuser/invite"
    static let registerPath = "api/appuser/register"

    static let shared = CSRESTManager()

    // Login into CosyncJWT
    func login(_ handle: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.loginPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                            URLQueryItem(name: "password", value: password.md5())]
        
        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            if let jwt = json["jwt"] as? String,
               let accessToken = json["access-token"] as? String {
                
                self.jwt = jwt
                self.accessToken = accessToken

                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }
        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Singup into CosyncJWT
    func signup(_ handle: String, password: String, signupData: String?, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.signupPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        if let signupData = signupData {
            requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                URLQueryItem(name: "password", value: password.md5()),
                                                URLQueryItem(name: "signupData", value: signupData)]

        } else {
            requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                URLQueryItem(name: "password", value: password.md5())]
        }
        
        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Complete Singup into CosyncJWT
    func completeSignup(_ handle: String, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.completeSignupPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                            URLQueryItem(name: "code", value: code)]

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            if let jwt = json["jwt"] as? String,
               let accessToken = json["access-token"] as? String,
               let signedUserToken = json["signed-user-token"] as? String {
                
                self.jwt = jwt
                self.accessToken = accessToken
                self.signedUserToken = signedUserToken

                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Get logged in user data from CosyncJWT
    func getUser(onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        if let accessToken = self.accessToken {
            
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["access-token": accessToken]

            let session = URLSession(configuration: config)
            
            let url = URL(string: "\(restPath)/\(CSRESTManager.getUserPath)")!
            
            let urlRequest = URLRequest(url: url)
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
            
                // ensure there is no error for this HTTP response
                guard error == nil else {
                    completion(error)
                    return
                }
                
                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(CSRESTError.internalServerError)
                    return
                }
                
                // serialise the data / NSData object into Dictionary [String : Any]
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    completion(CSRESTError.internalServerError)
                    return
                }
                
                if let uid = json["uid"] as? String {
                    self.uid = uid
                }
                
                if let handle = json["handle"] as? String {
                    self.handle = handle
                }
                
                if let isAdmin = json["uid"] as? String {
                    if isAdmin == "true" {
                        self.isAdmin = true
                    } else {
                        self.isAdmin = false
                    }
                } else {
                    self.isAdmin = false
                }
                
                if let onboardingData = json["onboardingData"] as? [String: Any] {
                    self.onboardingData = onboardingData
                }
                
                if let lastLogin = json["lastLogin"] as? String {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = .init(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    let date = dateFormatter.date(from:lastLogin)
                    if let date = date {
                        self.lastLogin = date
                    }
                }
                
                completion(nil)

            }
            
            // execute the HTTP request
            task.resume()
            
        } else {
            completion(CSRESTError.internalServerError)
        }
    }
    
    
    // Forgot Password into CosyncJWT
    func forgotPassword(_ handle: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.forgotPasswordPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle)]

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }
        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Reset password into CosyncJWT
    func resetPassword(_ handle: String, password: String, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.resetPasswordPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                            URLQueryItem(name: "password", value: password.md5()),
                                            URLQueryItem(name: "code", value: code)]

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Change password into CosyncJWT
    func changePassword(_ newPassword: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        
        if let accessToken = self.accessToken {
            let config = URLSessionConfiguration.default

            let session = URLSession(configuration: config)
            
            let url = URL(string: "\(restPath)/\(CSRESTManager.changePasswordPath)")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = ["access-token": accessToken]

            // your post request data
            var requestBodyComponents = URLComponents()
            
            requestBodyComponents.queryItems = [URLQueryItem(name: "newPassword", value: newPassword.md5()),
                                                URLQueryItem(name: "password", value: password.md5())]

            urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

            let task = session.dataTask(with: urlRequest) { data, response, error in
            
                // ensure there is no error for this HTTP response
                guard error == nil else {
                    completion(error)
                    return
                }
                
                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(CSRESTError.internalServerError)
                    return
                }
                
                let str = String(decoding: content, as: UTF8.self)
                
                if str == "true" {
                    completion(nil)
                } else {
                    completion(CSRESTError.internalServerError)
                }

            }
            
            // execute the HTTP request
            task.resume()
        }

    }
    
    // Get application data from CosyncJWT
    func getApplication(onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["app-token": appToken]

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.getApplicationPath)")!
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            if let name = json["name"] as? String {
                self.appName = name
            }
                        
            if let appData = json["appData"] as? [String: Any] {
                self.appData = appData
            }
            
            completion(nil)

        }
        
        // execute the HTTP request
        task.resume()
            

    }
    
    func setAppData(_ appData: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let accessToken = Constants.SUPERUSER_ACCESS_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.setAppDataPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["access-token": accessToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "appData", value: appData)]
        
        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
 
    // Invite into CosyncJWT
    func invite(_ handle: String, inviteData: String?, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        if let accessToken = self.accessToken {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let url = URL(string: "\(restPath)/\(CSRESTManager.invitePath)")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = ["access-token": accessToken]

            // your post request data
            var requestBodyComponents = URLComponents()
            if let inviteData = inviteData {
                requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                    URLQueryItem(name: "inviteData", value: inviteData)]

            } else {
                requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle)]
            }
            
            urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

            let task = session.dataTask(with: urlRequest) { data, response, error in
            
                // ensure there is no error for this HTTP response
                guard error == nil else {
                    completion(error)
                    return
                }
                
                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(CSRESTError.internalServerError)
                    return
                }
                
                let str = String(decoding: content, as: UTF8.self)
                
                if str == "true" {
                    completion(nil)
                } else {
                    completion(CSRESTError.internalServerError)
                }

            }
            
            // execute the HTTP request
            task.resume()
        }

    }
    
    // register into CosyncJWT
    func register(_ handle: String, password: String, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(CSRESTManager.registerPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                            URLQueryItem(name: "password", value: password.md5()),
                                            URLQueryItem(name: "code", value: code)]
        
        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            guard error == nil else {
                completion(error)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(CSRESTError.internalServerError)
                return
            }
            
            if let jwt = json["jwt"] as? String,
               let accessToken = json["access-token"] as? String,
               let signedUserToken = json["signed-user-token"] as? String {
                
                self.jwt = jwt
                self.accessToken = accessToken
                self.signedUserToken = signedUserToken

                completion(nil)
            } else {
                completion(CSRESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
    
    func logout() {
        self.jwt = nil
        self.accessToken = nil
        
        self.uid = nil
        self.handle = nil
        self.isAdmin = nil
        self.onboardingData = nil
        self.lastLogin = nil

    }

}

