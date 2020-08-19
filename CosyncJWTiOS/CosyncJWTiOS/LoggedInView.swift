//
//  LoggedInView.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/6/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import SwiftUI


struct LoggedInView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            
                
            VStack(spacing: 20) {
                Divider()
                Text(UserManager.shared.handle)
                Text(UserManager.shared.firstName)
                Text(UserManager.shared.lastName)
                Divider()
                
                NavigationLink(destination: InviteView()) {
                    Text("Invite Email")
                    Image(systemName: "person.crop.circle.badge.plus")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
                .font(.title)
                
                
                Spacer()
            }
            .padding()
            

            // Use .inline for the smaller nav bar
            .navigationBarTitle(Text("Logged In"), displayMode: .inline)
            .navigationBarItems(
                // Button on the leading side
                leading:
                Button(action: {
                    RESTManager.shared.logout()
                    RealmManager.shared.logout(onCompletion: { (err) in
                    })

                    self.appState.target = .loggedOut
                }) {
                    Text("Logout")
                }.accentColor(.blue),
                
                trailing:
                NavigationLink(destination: ChangePasswordView()) {
                    Text("Password")
                }
            )
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}


struct ChangePasswordView: View {
    @State private var password = ""
    @State private var newPassword = ""
    @EnvironmentObject var appState: AppState
    @State private var message: AlertMessage? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func showChangePasswordInvalidParameters(){
        self.message = AlertMessage(title: "Change Password Failed", message: "You have entered an invalid password", target: .none, state: self.appState)
    }

    func showChangePasswordSuccess(){
        self.message = AlertMessage(title: "Change Password Success", message: "Your password has been changed", target: .none, state: self.appState)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Divider()
            Group {
                SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)

                SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            }
            .padding(.horizontal)
            Divider()
            
            Button(action: {
                
                if  self.password.count > 0 &&
                    self.newPassword.count > 0  {
                    
                    RESTManager.shared.changePassword(self.newPassword, password: self.password, onCompletion: { (err) in
                            
                        DispatchQueue.main.async {
                            if let _ = err {
                                self.showChangePasswordInvalidParameters()
                            } else {
                                self.showChangePasswordSuccess()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    })
                    
                } else {
                    self.showChangePasswordInvalidParameters()
                }
                
                
            }) {
                Text("Change Password")
                    .padding(.horizontal)
                Image(systemName: "lock.rotation")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Spacer()
        }
        .navigationBarTitle("Change Password")
        .alert(item: $message) { message in
            Alert(message)
        }
    }
}

struct InviteView: View {
    @State private var email = ""
    @EnvironmentObject var appState: AppState
    @State private var message: AlertMessage? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func showInviteInvalidParameters(){
        self.message = AlertMessage(title: "Invite Failed", message: "You have entered an invalid email", target: .none, state: self.appState)
    }

    func showInviteSuccess(){
        self.message = AlertMessage(title: "Invite Success", message: "An invite code was sent to the email", target: .none, state: self.appState)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Divider()
            Group {
                TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .autocapitalization(UITextAutocapitalizationType.none)

                
            }
            .padding(.horizontal)
            Divider()
            
            Button(action: {
                
                if  self.email.count > 0   {
                    
                    RESTManager.shared.invite(self.email, metaData: nil, onCompletion: { (err) in
                            
                        DispatchQueue.main.async {
                            if let _ = err {
                                self.showInviteInvalidParameters()
                            } else {
                                self.showInviteSuccess()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    })
                    
                } else {
                    self.showInviteInvalidParameters()
                }
                
                
            }) {
                Text("Send Invite")
                    .padding(.horizontal)
                Image(systemName: "envelope")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Spacer()
        }
        .navigationBarTitle("Change Password")
        .alert(item: $message) { message in
            Alert(message)
        }
    }
}



struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}
