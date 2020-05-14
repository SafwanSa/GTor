//
//  LaunchView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct LaunchView: View {
    @ObservedObject var userService = UserService()
    
    
    var body: some View {
        VStack {
            Text("Name: \(self.userService.user.name)")
        }
        .onAppear{
            self.userService.configureAuthStateDidChnageListner()
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
