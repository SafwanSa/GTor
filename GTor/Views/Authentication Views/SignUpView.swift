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
    @Binding var isShowingLogin: Bool
    var isDisableGo: Bool {
        print(password.count < 6)
        print((name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isNewUser))
        print(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        
        return (password.count < 6 || (name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isNewUser) || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

    }
    var body: some View {
        ZStack {
            VStack {                
                VStack(spacing: 20.0) {
                    Text(isNewUser ? "Sign up" : "Login")
                        .font(.system(size: 32))
                        .foregroundColor(Color("Primary"))
                        .padding(.bottom, 40)
                    
                    
                    if isNewUser {
                        TextField("Name", text: $name)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color("Level 0"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow()
                    }
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()

                    
                    SecureField("Password (At least 6 digits)", text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()

                    
                    Text(alertMessage)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                
                Button(action: isNewUser ? signup : signin) {
                    Text("Go")
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color("Button"))
                        .foregroundColor(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                }
                .padding(.horizontal, 20)
                .opacity(isDisableGo ? 0.5 : 1)
                .disabled(isDisableGo)
                Spacer()
                Text("Back")
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("Button"))
                    .onTapGesture {
                        self.isShowingLogin = false
                }
            }
            .padding(.vertical, 30)
            
            LoadingView(isLoading: self.$isLoading)
        }
        
    }
    
    
    func signup() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        isLoading = true
        self.authService.createUser(name: name, email: email, password: password) { (result) in
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
        SignUpView(isShowingLogin: .constant(true))
    }
}
