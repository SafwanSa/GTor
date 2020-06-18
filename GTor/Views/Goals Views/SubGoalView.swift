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
    @State var isShowingDeleteAlert = false
    
    @State var updatedImportance: Importance = Importance.none
    @State var updatedTitle: String = ""
    @State var updatedNote: String = ""
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40.0) {
                    
                    GoalHeaderView(goal: goal, isEditingMode: $isEditingMode, updatedTitle: $updatedTitle, updatedNote: $updatedNote)

                    if self.goal.dueDate != nil{
                        HStack {
                            Text("Deadline")
                            Spacer()
                            Text("\(goal.dueDate!, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.trailing, 5)
                        }
                        .modifier(SmallCell())
                    }
                    
                    ImportanceCard(goal: goal, isEditingMode: $isEditingMode)
                    
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
                    .alert(isPresented: $isShowingAlert) {
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
            .navigationBarTitle("\(goal.title)")
            .navigationBarItems(trailing:
                Group {
                    HStack(spacing: 50) {
                        if isEditingMode {
                            Button(action: { self.isEditingMode = false }) {
                                Text("Cancel")
                            }
                            Button(action: saveGoal) {
                                Text("Save")
                            }
                        }else if !isEditingMode{
                            Button(action: { self.isEditingMode = true }) {
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
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
        
        }
        
    func deleteGoal(){
        mainGoal.subGoals?.removeAll(where: { (goal) -> Bool in
            return goal.id == self.goal.id
        })
        goalService.updateSubGoals(goal: mainGoal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = "Successfully deleted"
            }
        }
    }
    
    
    func saveGoal() {
        var goalCopy = goal
        var mainGoalCopy = mainGoal
        
        if goalCopy.importance != self.updatedImportance && updatedImportance != Importance.none {
            goalCopy.importance = updatedImportance
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
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
                self.isEditingMode = false
            case .success(()):
                self.isLoading = false
                self.isEditingMode = false
                self.isShowingAlert = true
                self.alertMessage = "Successfully Saved"
            }
        }
    }
}

struct SubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SubGoalView(goal: .dummy, mainGoal: .dummy)
    }
}
