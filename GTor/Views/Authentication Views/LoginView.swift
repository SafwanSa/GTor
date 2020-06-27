//
//  ContentView.swift
//  GTor
//
//  Created by Safwan Saigh on 13/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var isNewUser = false
    @State var isShowingLogin = false
    var body: some View {
        ZStack {
                if !isShowingLogin{
                VStack(spacing: 20.0) {
                        Text("Welcome Tester")
                            .font(.largeTitle)
                        Text("Please send me feedbacks for any issues. ")
                        
                        Text("NOTE: Ignore the Colors and the Authentication functionality")
                            .multilineTextAlignment(.center)
                    
                        Text("GTor")
                            .font(.largeTitle)
                            .foregroundColor(Color("Level 4"))
                        
                        VStack(spacing: 30.0) {
                            Button(action: { self.isShowingLogin = true ; self.isNewUser = true }) {
                                Text("Sign up")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { self.isShowingLogin = true ; self.isNewUser = false }) {
                                Text("Sign in")
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                        .foregroundColor(Color("Level 4"))
                    }
                    .padding(.top)
                    .onAppear {
                        print(AuthService.userId ?? "nil")
                    }
                
                }else {
                    if Auth.auth().currentUser == nil {
                        SignUpView(isNewUser: isNewUser)
                    }else {
                        TabBar()
                    }
                }
        }
        .onAppear {
            if Auth.auth().currentUser == nil { self.isShowingLogin = false } else { self.isShowingLogin = true }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
