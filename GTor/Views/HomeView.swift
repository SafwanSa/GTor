//
//  HomeView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import FirebaseAuth
let screen = UIScreen.main.bounds
struct HomeView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var authService = AuthService.shared
    
    var body: some View {
        VStack {
            Text("Hello, tester \(self.userService.user.email).")
            
            Button(action: { try! Auth.auth().signOut() }) {//TODO
                Text("Sign out")
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
