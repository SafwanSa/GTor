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
    @State var isLogingOut = false
    
    var body: some View {
        
        VStack {
            Text("Hello, tester \(UserService.shared.user.email)")
            
            Button(action: { try! Auth.auth().signOut() }) {
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
