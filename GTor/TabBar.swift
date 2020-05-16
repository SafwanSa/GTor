//
//  TabBar.swift
//  GTor
//
//  Created by Safwan Saigh on 16/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct TabBar: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var goalService: GoalService
    
    func signIn(){
        Auth.auth().signIn(withEmail: "safwan9f@gmail.com", password: "sa123456") { (result, err) in
            
        }
    }
    
    var body: some View {
        
        TabView {
            LaunchView().tabItem{
                Text("LaunchView")
                Image(systemName: "text.justify")
            }
            GoalsList().tabItem {
                Text("Goals")
                Image(systemName: "doc.text")
            }
        }
        .onAppear{
//            self.goalService.getGoalsFromDatabase(uid: User.dummyUser.uid)
                                self.goalService.goals.append(.dummy)
        }
                .onAppear{
        //                        try! Auth.auth().signOut()
        //            self.signIn()
                    self.userService.configureAuthStateDidChnageListner()
        //            self.goalService.getGoalsFromDatabase(uid: self.userService.user.uid)
                }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
