//
//  ForgetPasswordView.swift
//  GTor
//
//  Created by Safwan Saigh on 08/08/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State var email = ""
    @ObservedObject var authService = AuthService.shared
    @State var alertMessage = ""
    @State var isLoading = false

    var body: some View {
        ZStack {
            VStack(spacing: 15.0) {
                NewCardView(content: AnyView(
                    HStack {
                        TextField(NSLocalizedString("Email", comment: ""), text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Button(action: { self.email = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("Primary"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                ))
                
                Text(alertMessage)
                    .multilineTextAlignment(.center)
                
                Button(action: reset) {
                    Text(NSLocalizedString("Send", comment: ""))
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color("Button"))
                    .foregroundColor(Color("Level 0"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow()
                    
                }
                Spacer()
            }
            .padding()
            .padding(.top, 24)
            
            LoadingView(isLoading: $isLoading)
        }
    }
    
    func reset() {
        isLoading = true
        authService.forgotPassword(withEmail: email) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
                self.alertMessage = NSLocalizedString("The reset password email has been sent. Please check your email.  ", comment: "")
            }
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
