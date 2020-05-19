//
//  SubGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct SubGoalView: View {
    @ObservedObject var goalService = GoalService.shared
    var goal: Goal
    @State var mainGoal: Goal
    @State var isEditingMode = false
    @State var isShowingAlert = false
    
    @State var updatedImportance: String = Importance.none.description
    @State var updatedTitle: String = ""
    @State var updatedNote: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40.0) {
                
                HeaderView(goal: goal, isEditingMode: self.$isEditingMode, updatedTitle: self.$updatedTitle, updatedNote: self.$updatedNote)

                if self.goal.dueDate != nil{
                    HStack {
                        Text("Deadline")
                        Spacer()
                        Text(self.goal.dueDate?.description ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 5)
                    }
                    .modifier(SmallCell())
                }
                
                ImportanceCard(goal: goal, isEditingMode: self.$isEditingMode, updatedImportance: self.$updatedImportance)
                
                HStack {
                    Button(action: {  self.isShowingAlert = true  } ) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete the goal")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        
                    }
                }
                .modifier(SmallCell())
                .alert(isPresented: self.$isShowingAlert) {
                    Alert(title: Text("Are you sure you want to delete this goal?"),
                          primaryButton: .default(Text("Cancel")),
                          secondaryButton: .destructive(Text("Delete"), action: {
                            self.deleteGoal()
                    }))
                }
                
                
            }
            .animation(.spring())
            .padding(.top, 50)
        }
        .navigationBarTitle("\(self.goal.title ?? "Title")")
        .navigationBarItems(trailing:
            Group {
                HStack(spacing: 50) {
                    if self.isEditingMode {
                        Button(action: { self.isEditingMode = false }) {
                            Text("Cancel")
                        }
                        Button(action: { self.saveGoal(goal: self.goal, mainGoal: self.mainGoal) }) {
                            Text("Save")
                        }
                    }else if !self.isEditingMode{
                            Button(action: {self.isEditingMode = true }) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .imageScale(.large)
                                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                    .font(.headline)
                            }
                        }
                    }
                }
            )
        }
        
    func deleteGoal(){
        self.mainGoal.subGoals?.removeAll(where: { (goal) -> Bool in
            return goal.id == self.goal.id
        })
        self.goalService.updateSubGoals(goal: self.mainGoal) { (result) in
            switch result {
            case .failure(let error):
                self.isEditingMode = true
            case .success(()):
                self.isEditingMode = false
            }
        }
    }
    
    
    func saveGoal(goal: Goal, mainGoal: Goal) {
        var goalCopy = goal
        var mainGoalCopy = mainGoal
        
        if goalCopy.importance?.description != self.updatedImportance && updatedImportance != Importance.none.description {
            goalCopy.importance = Goal.stringToImportance(importance: self.updatedImportance)
        }
        if goalCopy.title != self.updatedTitle && !updatedTitle.isEmpty {
            goalCopy.title = self.updatedTitle
        }
        if goalCopy.note != self.updatedNote {
            goalCopy.note = self.updatedNote
        }
        
        mainGoalCopy.subGoals?.removeAll(where: { (goal) -> Bool in
                return goal.id == goalCopy.id
        })
        mainGoalCopy.subGoals?.append(goalCopy)

        goalService.updateGoal(goal: mainGoalCopy) { (result) in
            switch result {
            case .failure(let error):
                self.isEditingMode = true
            case .success(()):
                self.isEditingMode = false
            }
        }
    }
}

struct SubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SubGoalView(goal: .dummy, mainGoal: .dummy)
    }
}
