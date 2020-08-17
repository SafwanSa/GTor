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
    @State var gender : String = ""
    @State var arrGenders = ["Male","Female"]
    @State var selectionIndex = 0
    
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var alertMessage = ""
    @State var isLoading = false
    @Binding var isNewUser: Bool
    @Binding var isShowingLogin: Bool
    var isDisableGo: Bool {
        return (password.count < 6 || (name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isNewUser) || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (gender.isEmpty && isNewUser))
        
    }
    @State var isShowingForgotPassword = false
    
    var body: some View {
        ZStack {
            VStack {                
                VStack(spacing: 20.0) {
                    Text(isNewUser ? NSLocalizedString("signUp", comment: "") : NSLocalizedString("login", comment: ""))
                        .font(.system(size: 32))
                        .foregroundColor(Color("Primary"))
                        .padding(.bottom, 40)
                    
                    
                    if isNewUser {
                        TextField(NSLocalizedString("name", comment: ""), text: $name)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color("Level 0"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow()
                        
                        TextFieldWithPickerAsInputView(data: self.arrGenders,
                                                       placeholder: NSLocalizedString("gender", comment: ""),
                                                       selectionIndex: self.$selectionIndex,
                                                       text: self.$gender)
                            
                            .frame(height: 20)
                            .padding()
                            .background(Color("Level 0"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow()
                    }
                    
                    TextField(NSLocalizedString("email", comment: ""), text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                    
                    
                    SecureField(NSLocalizedString("passwordLimit", comment: ""), text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                    
                    
                    if !isNewUser {
                        Text(NSLocalizedString("forgotPassword", comment: ""))
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onTapGesture {
                                self.isShowingForgotPassword = true
                        }
                        .sheet(isPresented: $isShowingForgotPassword) {
                            ForgetPasswordView()
                        }
                        
                        
                    }
                    Text(alertMessage)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .foregroundColor(Color("Primary"))
                
                Button(action: isNewUser ? signup : signin) {
                    Text(NSLocalizedString("go", comment: ""))
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
                
                HStack(spacing: 0.0) {
                    Text(NSLocalizedString(isNewUser ? "alreadyHaveAccount" : "dontHaveAccount", comment: ""))
                        .foregroundColor(Color("Primary"))
                        
                    Text(NSLocalizedString(isNewUser ? "signIn" : "signUp", comment: ""))
                        .foregroundColor(Color("Button"))
                        .onTapGesture {
                            self.isNewUser.toggle()
                        }
                }
                .padding(.top)


                
                Spacer()
                Text(NSLocalizedString("back", comment: ""))
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
        guard let gender = Gender.init(rawValue: self.gender) else { return }
        isLoading = true
        self.authService.createUser(name: name, gender: gender, email: email, password: password) { (result) in
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
        SignUpView(isNewUser: .constant(false), isShowingLogin: .constant(true))
    }
}
