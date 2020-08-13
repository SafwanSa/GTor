//
//  LaunchView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import FirebaseAuth
let screen = UIScreen.main.bounds
let currentLanguage: String = Locale.current.languageCode ?? "en"
let appVersion = 1.0

struct LaunchView: View {
    @ObservedObject var userService = UserService.shared
    var notificationService = NotificationService.shared
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    if userService.authState == .udefined || userService.authState == .signOut {
                        LoginView()
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut)
                    }else {
                        TabBar()
                    }
                }
            }
            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            self.isLoading = true
            self.userService.configureAuthStateDidChangeListner { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.isLoading = false
                }
            }
            self.notificationService.sendRequest { (result) in
                switch result {
                case .failure(let error):
                    print("Error while sending requests. ", error.localizedDescription)
                case .success(let response):
                    print("User responded with: ", response)
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

