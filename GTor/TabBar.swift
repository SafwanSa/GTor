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

    
    init() {
           UITabBar.appearance().barTintColor = UIColor(named: "Level 1")
           UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Level 2")
    }
    
    var body: some View {
        TabView {
            HomeView().tabItem {
                Text("Home")
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
            print(self.userService.user.uid)
            self.userService.configureAuthStateDidChangeListner()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
