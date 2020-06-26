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
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @ObservedObject var taskService = TaskService.shared

    func signIn() {
        Auth.auth().signIn(withEmail: "safwan9f@gmail.com", password: "sa123456") { (result, err) in
            
        }
    }
    
    init() {
           UITabBar.appearance().barTintColor = UIColor(named: "Level 0")
           UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Level 2")
    }
    
    var body: some View {
        
        TabView {
            LaunchView().tabItem {
                Text("LaunchView")
                Image(systemName: "text.justify")
            }
            GoalsList().tabItem {
                Text("Goals")
                Image(systemName: "doc.text")
            }
            
            TODOList().tabItem {
                Text("TODO")
                Image(systemName: "doc.text")
            }
        }
        .accentColor(Color("Level 4"))
            .onAppear {
            
//                        try! Auth.auth().signOut()
//                        self.signIn()
            self.userService.configureAuthStateDidChnageListner()
            self.taskService.getTasksFromDatabase()
            self.goalService.getGoalsFromDatabase()//This should be moved to the configureAuthStateDidChnageListner
//                                            self.goalService.goals.append(.dummy)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
