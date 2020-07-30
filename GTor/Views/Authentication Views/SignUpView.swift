//
//  SignUpView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authService = AuthService.shared
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var alertMessage = ""
    @State var isLoading = false
    var isNewUser = false
    
    var body: some View {
        ZStack {
            VStack {                
                VStack(spacing: 20.0) {
                    if isNewUser {
                        TextField("Name", text: $name)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color("Level 0"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow()
                        .keyboardAware()
                    }
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                    .keyboardAware()

                    
                    SecureField("Password (At least 6 digits)", text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                    .keyboardAware()

                    
                    Text(alertMessage)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                
                Button(action: isNewUser ? signup : signin) {
                    Text("Go")
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color("Button"))
                        .foregroundColor(Color("Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                }
                .padding(.horizontal, 20)
            }
            
            LoadingView(isLoading: self.$isLoading)
        }
        
    }
    
    
    func signup() {
        isLoading = true
        self.authService.createUser(name: "Tester.", email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.isLoading = false
            case .success(()):
                self.isLoading = false
            }
        }
    }
    
    func signin() {
        isLoading = true
        self.authService.signInUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.isLoading = false
            case .success(()):
                self.isLoading = false
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
