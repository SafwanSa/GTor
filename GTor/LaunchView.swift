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
    @ObservedObject var userService = UserService()
    @ObservedObject var goalService = GoalService()
    @State var msg = ""
    
    func signUp(){
        AuthService.createUser(name: "Safwans", email: "safwan9f@gmail.com", password: "sa123456") { (result) in
            switch result {
            case .failure(let error):
                self.msg = error.localizedDescription
            case .success():
                self.msg = "Success"
            }
        }
    }
    
    func delete(){
        FirestoreService.shared.deleteDocument(collection: .users, documentId: self.userService.user.uid, model: self.userService.user) { (result) in
            switch result {
            case .failure(let error):
                self.msg = error.localizedDescription
            case .success():
                self.msg = "Success"
            }
        }
    }
    
    
    func createGoal(){
        let goal = Goal(uid: self.userService.user.uid, title: "Goal1", note: "note1", importance: .important, satisfaction: 0, dueDate: Date(), categories: [], subGoals: [], tasks: [])
        self.goalService.saveGoalsToDatabase(goal: goal) { (result) in
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
            
            Button(action: delete) {
                Text("Delete Doc")
            }
            
            Button(action: createGoal) {
                Text("Add goal")
            }
        }
        .onAppear{
            //            try! Auth.auth().signOut()
            self.userService.configureAuthStateDidChnageListner()
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

