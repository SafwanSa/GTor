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
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

struct LaunchView: View {
    @ObservedObject var userService = UserService.shared
    var notificationService = NotificationService.shared
    @State var isLoading = true
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    if userService.authState == .udefined || userService.authState == .signOut {
                        if isLoading {
                            LogoView()
                        }else {
                            LoginView()
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut)
                        }
                        
                    }else {
                        if isLoading {
                            LogoView()
                        }else {
                            TabBar()
                        }
                    }
                }
            }
            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            self.userService.configureAuthStateDidChangeListner { (complete) in
                if complete {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.isLoading = false
                    }
                }else {
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
        LogoView()
    }
}



struct LogoView: View {
    var body: some View {
        VStack {
            Image("Trans-Gtor-New-Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 367, height: 311)
        }
    }
}
