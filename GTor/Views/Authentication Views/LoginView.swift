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
    @ObservedObject var userService = UserService.shared
    @State var isNewUser = false
    @State var isShowingLogin = false
    var body: some View {
        Group {
            if !isShowingLogin {
                VStack {
                    Image("Trans-Gtor-New-Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    Spacer()
                    VStack(spacing: 20.0) {
                        LoginButton(text: "Create an account", background: Color("Button"), foreground: Color("Level 0"),
                                    action: { self.isShowingLogin = true ; self.isNewUser = true })
                        LoginButton(text: "Login", background: Color("Level 0"), foreground: Color("Button"),
                                    action: { self.isShowingLogin = true ; self.isNewUser = false })
                    }
                    .frame(width: screen.width-200)
                }
                .padding(.vertical, 70)
            }else {
                SignUpView(isNewUser: self.isNewUser, isShowingLogin: $isShowingLogin)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LoginButton: View {
    var text: String
    var background: Color
    var foreground: Color
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity)
                .padding()
                .background(background)
                .foregroundColor(foreground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.12), radius: 15, x: 0, y: 7)
                .elevation()
        }
    }
}
