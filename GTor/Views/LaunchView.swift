//
//  LaunchView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import FirebaseAuth
struct LaunchView: View {
    @ObservedObject var userService = UserService.shared
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            Group {
                if userService.authState == .udefined || userService.authState == .signOut {
                    LoginView()
                }else {
                    TabBar()
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
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

