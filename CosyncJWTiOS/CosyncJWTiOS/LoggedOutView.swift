//
//  LoggedOutView.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import SwiftUI

struct LoggedOutView: View {
    var body: some View {
        TabView {

            LoginTab().tabItem {
                Image(systemName: "arrow.right.square")
                Text("Login")
            }
            SignupTab().tabItem {
                Image(systemName: "person.badge.plus")
                Text("Signup")
            }
        }
    }
}

struct LoginTab: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var appState: AppState
    @State private var message: AlertMessage? = nil

    func showLoginInvalidParameters(){
        self.message = AlertMessage(title: "Login Failed", message: "You have entered an invalid handle or password.", target: .none, state: self.appState)
    }

    func showLoginError(message: String){
        self.message = AlertMessage(title: "Login Failed", message: message, target: .none, state: self.appState)
    }

    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("CosyncJWT iOS")
                .font(.largeTitle)
            
            Divider()
            
            Group {
                TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .autocapitalization(UITextAutocapitalizationType.none)
            
                SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            }
            .padding(.horizontal)
            
            Divider()
            
            Button(action: {

                if self.email.count > 0 && self.password.count > 0 {
                    
                    UserManager.shared.login(email: self.email, password: self.password) { (error) in
                        
                        DispatchQueue.main.async {
                            if error != nil {
                                self.showLoginInvalidParameters()
                            } else {
                                self.appState.target = .loggedIn
                            }
                        }
                    }
                    
                } else {
                    self.showLoginInvalidParameters()
                }

            }) {
                Text("Login")
                    .padding(.horizontal)
                Image(systemName: "arrow.right.square")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Button(action: {
                self.appState.target = .password
            }) {
                Text("forgot password")
                .font(.body)
            }
            .padding()
            

        }.font(.title)
        .alert(item: $message) { message in
            Alert(message)
        }
    }
}


enum SignupUI: Int {
    case signup
    case verifyCode
}

struct SignupTab: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var inviteCode = ""
    @State private var code = ""
    @EnvironmentObject var appState: AppState
    @State private var message: AlertMessage? = nil
    @State var signupUI: SignupUI = .signup
    
    func showSignupInvalidParameters(){
        self.message = AlertMessage(title: "Signup Failed", message: "You have entered an invalid handle or password.", target: .none, state: self.appState)
    }

    func showSignupError(message: String){
        self.message = AlertMessage(title: "Signup Failed", message: message, target: .none, state: self.appState)
    }

    func showSignupInvalidCode(){
        self.message = AlertMessage(title: "Signup Failed", message: "You have entered an invalid 6 digit code", target: .none, state: self.appState)
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("CosyncJWT iOS")
                .font(.largeTitle)
            
            Divider()
            
            Group {
                if self.signupUI == .signup {
                    TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .autocapitalization(UITextAutocapitalizationType.none)
                
                    SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    
                    TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .autocapitalization(UITextAutocapitalizationType.none)

                    TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .autocapitalization(UITextAutocapitalizationType.none)

                    TextField("Invite Code", text: $inviteCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .autocapitalization(UITextAutocapitalizationType.none)

                }
                
                else {
                    Text("A six digit code was sent to your email, please enter it below to verify your identity")
                    
                    TextField("Code", text: $code)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    
                }
                
            }
            .padding(.horizontal)
            
            Divider()
            
            if self.signupUI == .signup {
                Button(action: {
                    
                    if  self.email.count > 0 &&
                        self.password.count > 0 &&
                        self.firstName.count > 0 &&
                        self.lastName.count > 0 &&
                        (self.inviteCode.count == 0 ||
                            (self.inviteCode.count > 0 && self.inviteCode.isNumeric)) {
                        
                        let metaData = "{\"user_data\": {\"name\": {\"first\": \"\(self.firstName)\", \"last\": \"\(self.lastName)\"}}}"
                        
                        if self.inviteCode.count == 0 {
                        
                            RESTManager.shared.signup(self.email, password: self.password, metaData: metaData, onCompletion: { (err) in
                                    
                                DispatchQueue.main.async {
                                    if let error = err as? RESTError {
                                        self.showSignupError(message: error.message)
                                    } else {
                                        self.signupUI = .verifyCode
                                    }
                                }
                            })
                        } else {
                            
                            RESTManager.shared.register(self.email, password: self.password, metaData: metaData, code: self.inviteCode, onCompletion: { (err) in
                                    
                                DispatchQueue.main.async {
                                    if let error = err as? RESTError {
                                        self.showSignupError(message: error.message)
                                    } else {
                                        UserManager.shared.login(email: self.email, password: self.password) { (err) in
                                            DispatchQueue.main.async {
                                                if let error = err as? RESTError {
                                                    self.showSignupError(message: error.message)
                                                } else {
                                                    self.appState.target = .loggedIn
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    } else {
                        self.showSignupInvalidParameters()
                    }
                    
                    
                }) {
                    Text("Signup")
                        .padding(.horizontal)
                    Image(systemName: "person.badge.plus")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
            } else {
                Button(action: {
                    
                    if self.code.isNumeric && self.code.count == 6 {
                        
                        RESTManager.shared.completeSignup(self.email, code: self.code, onCompletion: { (err) in
                            
                            DispatchQueue.main.async {
                                if let error = err as? RESTError {
                                    self.showSignupError(message: error.message)
                                 } else {
                                    
                                    UserManager.shared.login(email: self.email, password: self.password) { (err) in
                                        DispatchQueue.main.async {
                                            if let error = err as? RESTError {
                                                self.showSignupError(message: error.message)
                                            } else {
                                                self.signupUI = .signup
                                                self.appState.target = .loggedIn
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        })
                        
                        
                    } else {
                        self.showSignupInvalidCode()
                    }
                    
                }) {
                    Text("Verify Code")
                        .padding(.horizontal)
                    Image(systemName: "envelope")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
            }

        }.font(.title)
        .alert(item: $message) { message in
            Alert(message)
        }

    }
}


struct LoggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutView()
    }
}
