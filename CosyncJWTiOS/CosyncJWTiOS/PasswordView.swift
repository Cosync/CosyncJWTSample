//
//  PasswordView.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/13/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation
import SwiftUI

enum PasswordUI: Int {
    case password
    case verifyCode
}

struct PasswordView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var appState: AppState
    @State private var message: AlertMessage? = nil
    @State var passwordUI: PasswordUI = .password
    @State private var code = ""
    
    func forgotPasswordInvalidParameters() {
        self.message = AlertMessage(title: "Forgot Password Failed", message: "You have entered an invalid handle.", target: .none, state: self.appState)
    }
    
    func forgotPasswordInvalidCode() {
        self.message = AlertMessage(title: "Forgot Password Failed", message: "You have entered an invalid password or code.", target: .none, state: self.appState)
    }

    func forgotPasswordError(message: String){
        self.message = AlertMessage(title: "Signup Failed", message: message, target: .none, state: self.appState)
    }
    
    func forgotPasswordSuccess() {
        self.message = AlertMessage(title: "Forgot Password Success", message: "Your password has been changed.", target: .loggedOut, state: self.appState)
    }
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 25) {
            
                Divider()
                Group {
                    TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    .disabled(self.passwordUI != .password)
                
                    if self.passwordUI == .verifyCode {
                        
                        Text("A six digit code was sent to your email, please enter it below to verify your identity")
                        
                        SecureField("New Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        
                        TextField("Code", text: $code)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    }
                }
                .padding(.horizontal)
                Divider()
                    
                if self.passwordUI == .password {
                    Button(action: {
                        
                        if  self.email.count > 0 {
                            
                            RESTManager.shared.forgotPassword(self.email, onCompletion: { (error) in
                                    
                                DispatchQueue.main.async {
                                    if let error = error as? RESTError {
                                        self.forgotPasswordError(message: error.message)
                                    } else {
                                        self.passwordUI = .verifyCode
                                    }
                                }
                            })
                            
                        } else {
                            self.forgotPasswordInvalidParameters()
                        }
                        
                        
                    }) {
                        Text("Send Code")
                            .padding(.horizontal)
                        Image(systemName: "envelope")
                    }
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                } else if self.passwordUI == .verifyCode {
                    Button(action: {
                        
                        if self.password.count > 0 && self.code.isNumeric && self.code.count == 6 {
                            
                            RESTManager.shared.resetPassword(self.email, password: self.password, code: self.code, onCompletion: { (error) in
                                    
                                DispatchQueue.main.async {
                                    if let error = error as? RESTError {
                                        self.forgotPasswordError(message: error.message)
                                    } else {
                                        self.forgotPasswordSuccess()
                                        self.passwordUI = .password
                                    }
                                }
                            })
                            
                        } else {
                            self.forgotPasswordInvalidCode()
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
                
                Spacer()
            }
            .alert(item: $message) { message in
                       Alert(message)
                   }


            // Use .inline for the smaller nav bar
            .navigationBarTitle(Text("Forgot Password"), displayMode: .inline)
            .navigationBarItems(
                // Button on the leading side
                leading:
                Button(action: {

                    self.appState.target = .loggedOut
                }) {
                    Text("Back")
                }.accentColor(.blue)
            )
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
