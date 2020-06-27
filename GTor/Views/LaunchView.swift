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
    @ObservedObject var goalService = GoalService.shared
    
    @State var msg = ""
    
    
    func signIn(){
        Auth.auth().signIn(withEmail: "safwan9f@gmail.com", password: "sa123456") { (result, err) in
            
        }
    }
    
    func signUp(){
        AuthService.shared.createUser(name: "Safwans", email: "safwan9f@gmail.com", password: "sa123456") { (result) in
            switch result {
            case .failure(let error):
                self.msg = error.localizedDescription
            case .success():
                self.msg = "Success"
            }
        }
    }
    
    
    func createGoal(){
        self.goalService.saveGoalsToDatabase(goal: Goal.dummy) { (result) in
            switch result {
            case .failure(let error):
                self.msg = error.localizedDescription
            case .success():
                self.msg = "Success"
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Button(action: signUp) {
                Text("Sign up")
            }
            Text("Name: \(self.userService.user.name)")
            Text(self.msg)
            
            Button(action: {}) {
                Text("Delete Doc")
            }
            
            Button(action: createGoal) {
                Text("Add goal")
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

