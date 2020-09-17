//
//  RESTManager.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation
import CryptoSwift

class RESTManager {
    
    // Login credentials
    var jwt: String?
    var accessToken: String?
    
    // complete signup credentials
    var signedUserToken: String?
    
    // Logged in user information
    var uid: String?
    var handle: String?
    var metaData: [String:Any]?
    var lastLogin: Date?
    
    // application data
    var appName: String?
    var twoFactorVerification: String?
    var passwordFilter: Bool?
    var passwordMinLength: Int?
    var passwordMinUpper: Int?
    var passwordMinLower: Int?
    var passwordMinDigit: Int?
    var passwordMinSpecial: Int?
    
    var appData: [String:Any]?
    
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

    static let shared = RESTManager()

    // Login into CosyncJWT
    func login(_ handle: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(RESTManager.loginPath)")!
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
            let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
            guard errorResponse == nil  else {
                completion(errorResponse)
                return
            }

            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(RESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(RESTError.internalServerError)
                return
            }
            
            if let jwt = json["jwt"] as? String,
               let accessToken = json["access-token"] as? String {
                
                self.jwt = jwt
                self.accessToken = accessToken

                completion(nil)
            } else {
                completion(RESTError.internalServerError)
            }
        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Singup into CosyncJWT
    func signup(_ handle: String, password: String, metaData: String?, onCompletion completion: @escaping (Error?) -> Void) {

        RESTManager.shared.getApplication(onCompletion: { (err) in
            
            if let error = err {
                completion(error)
            } else {
                
                if self.checkPassword(password) {
                    let restPath = Constants.COSYNC_REST_ADDRESS
                    let appToken = Constants.APP_TOKEN
                    
                    let config = URLSessionConfiguration.default

                    let session = URLSession(configuration: config)
                    
                    let url = URL(string: "\(restPath)/\(RESTManager.signupPath)")!
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.allHTTPHeaderFields = ["app-token": appToken]

                    // your post request data
                    var requestBodyComponents = URLComponents()
                    if let metaData = metaData {
                        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                            URLQueryItem(name: "password", value: password.md5()),
                                                            URLQueryItem(name: "metaData", value: metaData)]

                    } else {
                        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                            URLQueryItem(name: "password", value: password.md5())]
                    }
                    
                    urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

                    let task = session.dataTask(with: urlRequest) { data, response, error in
                    
                        // ensure there is no error for this HTTP response
                        let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                        guard errorResponse == nil  else {
                            completion(errorResponse)
                            return
                        }

                        // ensure there is data returned from this HTTP response
                        guard let content = data else {
                            completion(RESTError.internalServerError)
                            return
                        }
                        
                        let str = String(decoding: content, as: UTF8.self)
                        
                        if str == "true" {
                            completion(nil)
                        } else {
                            completion(RESTError.internalServerError)
                        }

                    }
                    
                    // execute the HTTP request
                    task.resume()
                } else {
                    completion(RESTError.invalidPassword)
                }
            }
        })

    }
    
    func checkPassword(_ password: String) -> Bool {
        
        if let passwordFilter = self.passwordFilter,
               passwordFilter {
            
            if  let passwordMinLength = self.passwordMinLength,
                password.count < passwordMinLength {
                return false
            }
            
            if  let passwordMinUpper = self.passwordMinUpper {
                let characters = Array(password)
                var count = 0
                for c in characters {
                    let cs = String(c)
                    if cs == cs.uppercased() && cs != cs.lowercased() {
                        count += 1
                    }
                }
                if count < passwordMinUpper {
                    return false
                }
                
            }
            
            if  let passwordMinLower = self.passwordMinLower {
                let characters = Array(password)
                var count = 0
                for c in characters {
                    let cs = String(c)
                    if cs == cs.lowercased() && cs != cs.uppercased() {
                        count += 1
                    }
                }
                if count < passwordMinLower {
                    return false
                }
            }
            
            if  let passwordMinDigit = self.passwordMinDigit {
                let characters = Array(password)
                var count = 0
                for c in characters {
                    if c.isASCII && c.isNumber {
                        count += 1
                    }
                }
                if count < passwordMinDigit {
                    return false
                }
            }
                
            if  let passwordMinSpecial = self.passwordMinSpecial {
                let characterset = CharacterSet(charactersIn: "@%+\\/‘!#$^?:()[]~`-_.,")
                
                let characters = password.unicodeScalars
                var count = 0
                for c in characters {
                    if characterset.contains(c) {
                        count += 1
                    }
                }
                if count < passwordMinSpecial {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Complete Singup into CosyncJWT
    func completeSignup(_ handle: String, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(RESTManager.completeSignupPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                            URLQueryItem(name: "code", value: code)]

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
            guard errorResponse == nil  else {
                completion(errorResponse)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(RESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(RESTError.internalServerError)
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
                
                completion(RESTError.internalServerError)
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
            
            let url = URL(string: "\(restPath)/\(RESTManager.getUserPath)")!
            
            let urlRequest = URLRequest(url: url)
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
            
                // ensure there is no error for this HTTP response
                let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                guard errorResponse == nil  else {
                    completion(errorResponse)
                    return
                }

                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(RESTError.internalServerError)
                    return
                }
                
                // serialise the data / NSData object into Dictionary [String : Any]
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    completion(RESTError.internalServerError)
                    return
                }
                
                if let handle = json["handle"] as? String {
                    self.handle = handle
                }
                
                
                if let metaData = json["metaData"] as? [String: Any] {
                    self.metaData = metaData
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
            completion(RESTError.internalServerError)
        }
    }
    
    
    // Forgot Password into CosyncJWT
    func forgotPassword(_ handle: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(RESTManager.forgotPasswordPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["app-token": appToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle)]

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
            guard errorResponse == nil  else {
                completion(errorResponse)
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(RESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(RESTError.internalServerError)
            }
        }
        
        // execute the HTTP request
        task.resume()

    }
    
    // Reset password into CosyncJWT
    func resetPassword(_ handle: String, password: String, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        if self.checkPassword(password) {
            
            let restPath = Constants.COSYNC_REST_ADDRESS
            let appToken = Constants.APP_TOKEN
            
            let config = URLSessionConfiguration.default

            let session = URLSession(configuration: config)
            
            let url = URL(string: "\(restPath)/\(RESTManager.resetPasswordPath)")!
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
                let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                guard errorResponse == nil  else {
                    completion(errorResponse)
                    return
                }

                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(RESTError.internalServerError)
                    return
                }
                
                let str = String(decoding: content, as: UTF8.self)
                
                if str == "true" {
                    completion(nil)
                } else {
                    completion(RESTError.internalServerError)
                }

            }
            
            // execute the HTTP request
            task.resume()
            
        } else {
            completion(RESTError.invalidPassword)
        }

    }
    
    // Change password into CosyncJWT
    func changePassword(_ newPassword: String, password: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        if self.checkPassword(password) {
            
            let restPath = Constants.COSYNC_REST_ADDRESS
            
            if let accessToken = self.accessToken {
                let config = URLSessionConfiguration.default

                let session = URLSession(configuration: config)
                
                let url = URL(string: "\(restPath)/\(RESTManager.changePasswordPath)")!
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
                    let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                    guard errorResponse == nil  else {
                        completion(errorResponse)
                        return
                    }

                    // ensure there is data returned from this HTTP response
                    guard let content = data else {
                        completion(RESTError.internalServerError)
                        return
                    }
                    
                    let str = String(decoding: content, as: UTF8.self)
                    
                    if str == "true" {
                        completion(nil)
                    } else {
                        completion(RESTError.internalServerError)
                    }

                }
                
                // execute the HTTP request
                task.resume()
            }
            
        } else {
            completion(RESTError.invalidPassword)
        }
    }
    
    // Get application data from CosyncJWT
    func getApplication(onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        let appToken = Constants.APP_TOKEN

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["app-token": appToken]

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(RESTManager.getApplicationPath)")!
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
            guard errorResponse == nil  else {
                completion(errorResponse)
                return
            }

            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(RESTError.internalServerError)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(RESTError.internalServerError)
                return
            }
            
            if let name = json["name"] as? String {
                self.appName = name
            }
            
            if let twoFactorVerification = json["twoFactorVerification"] as? String {
                self.twoFactorVerification = twoFactorVerification
            }
            if let passwordFilter = json["passwordFilter"] as? Bool {
                self.passwordFilter = passwordFilter
            }
            if let passwordMinLength = json["passwordMinLength"] as? Int {
                self.passwordMinLength = passwordMinLength
            }
            if let passwordMinUpper = json["passwordMinUpper"] as? Int {
                self.passwordMinUpper = passwordMinUpper
            }
            if let passwordMinLower = json["passwordMinLower"] as? Int {
                self.passwordMinLower = passwordMinLower
            }
            if let passwordMinDigit = json["passwordMinDigit"] as? Int {
                 self.passwordMinDigit = passwordMinDigit
            }
            if let passwordMinSpecial = json["passwordMinSpecial"] as? Int {
                 self.passwordMinSpecial = passwordMinSpecial
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
        let accessToken = Constants.APP_SECRET
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        
        let url = URL(string: "\(restPath)/\(RESTManager.setAppDataPath)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["access-token": accessToken]

        // your post request data
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "appData", value: appData)]
        
        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            // ensure there is no error for this HTTP response
            let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
            guard errorResponse == nil  else {
                completion(errorResponse)
                return
            }

            // ensure there is data returned from this HTTP response
            guard let content = data else {
                completion(RESTError.internalServerError)
                return
            }
            
            let str = String(decoding: content, as: UTF8.self)
            
            if str == "true" {
                completion(nil)
            } else {
                completion(RESTError.internalServerError)
            }

        }
        
        // execute the HTTP request
        task.resume()

    }
 
    // Invite into CosyncJWT
    func invite(_ handle: String, metaData: String?, onCompletion completion: @escaping (Error?) -> Void) {
        
        let restPath = Constants.COSYNC_REST_ADDRESS
        if let accessToken = self.accessToken,
           let senderUserId = RealmManager.shared.app.currentUser()?.id {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let url = URL(string: "\(restPath)/\(RESTManager.invitePath)")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = ["access-token": accessToken]

            // your post request data
            var requestBodyComponents = URLComponents()
            if let metaData = metaData {
                requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                    URLQueryItem(name: "metaData", value: metaData),
                                                    URLQueryItem(name: "senderUserId", value: senderUserId)]

            } else {
                requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                    URLQueryItem(name: "senderUserId", value: senderUserId)]
            }
            
            urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

            let task = session.dataTask(with: urlRequest) { data, response, error in
            
                // ensure there is no error for this HTTP response
                let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                guard errorResponse == nil  else {
                    completion(errorResponse)
                    return
                }

                // ensure there is data returned from this HTTP response
                guard let content = data else {
                    completion(RESTError.internalServerError)
                    return
                }
                
                let str = String(decoding: content, as: UTF8.self)
                
                if str == "true" {
                    completion(nil)
                } else {
                    completion(RESTError.internalServerError)
                }

            }
            
            // execute the HTTP request
            task.resume()
        }

    }
    
    // register into CosyncJWT
    func register(_ handle: String, password: String, metaData: String?, code: String, onCompletion completion: @escaping (Error?) -> Void) {
        
        RESTManager.shared.getApplication(onCompletion: { (err) in
            
            if let error = err {
                completion(error)
            } else {
                
                if self.checkPassword(password) {

                    let restPath = Constants.COSYNC_REST_ADDRESS
                    let appToken = Constants.APP_TOKEN
                    
                    let config = URLSessionConfiguration.default

                    let session = URLSession(configuration: config)
                    
                    let url = URL(string: "\(restPath)/\(RESTManager.registerPath)")!
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.allHTTPHeaderFields = ["app-token": appToken]

                    // your post request data
                    var requestBodyComponents = URLComponents()
                    
                    if let metaData = metaData {
                        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                            URLQueryItem(name: "password", value: password.md5()),
                                                            URLQueryItem(name: "code", value: code),
                                                            URLQueryItem(name: "metaData", value: metaData)]

                    } else {
                        requestBodyComponents.queryItems = [URLQueryItem(name: "handle", value: handle),
                                                            URLQueryItem(name: "password", value: password.md5()),
                                                            URLQueryItem(name: "code", value: code)]
                    }
                    
                    urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

                    let task = session.dataTask(with: urlRequest) { data, response, error in
                    
                        // ensure there is no error for this HTTP response
                        let errorResponse = RESTError.checkResponse(data: data, response: response, error: error)
                        guard errorResponse == nil  else {
                            completion(errorResponse)
                            return
                        }

                        // ensure there is data returned from this HTTP response
                        guard let content = data else {
                            completion(RESTError.internalServerError)
                            return
                        }
                        
                        // serialise the data / NSData object into Dictionary [String : Any]
                        guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                            completion(RESTError.internalServerError)
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
                            completion(RESTError.internalServerError)
                        }

                    }
                    
                    // execute the HTTP request
                    task.resume()
                    
                    
                } else {
                    completion(RESTError.invalidPassword)
                }
            }
        })
        
    }
    
    func logout() {
        self.jwt = nil
        self.accessToken = nil
        
        self.uid = nil
        self.handle = nil
        self.metaData = nil
        self.lastLogin = nil

    }

}
