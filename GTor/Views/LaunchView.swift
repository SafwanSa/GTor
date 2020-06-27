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
    
    var body: some View {
        Group {
            if userService.authState == .udefined || userService.authState == .signOut {
                LoginView()
            }else {
                TabBar()
            }
        }
        .onAppear {
            self.userService.configureAuthStateDidChangeListner()
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

