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
    @State var isLoading = false
    
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "Level 1")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Level 2")
    }
    
    var body: some View {
        ZStack {
            TabView {
                HomeScreenView().tabItem {
                    Text(NSLocalizedString("home", comment: ""))
                    Image(systemName: "house")
                }
                GoalsList().tabItem {
                    Text(NSLocalizedString("goals", comment: ""))
                    Image(systemName: "doc.text")
                }
                
                NewTODOListView().tabItem {
                    Text(NSLocalizedString("tasks", comment: ""))
                    Image(systemName: "rectangle.grid.1x2")
                }
            }
            .accentColor(Color("Primary"))
            
            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            self.isLoading = true
            self.userService.configureAuthStateDidChangeListner { _ in
                self.isLoading = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    print(self.userService.user.uid)
                }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
