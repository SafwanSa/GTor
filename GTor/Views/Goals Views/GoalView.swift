//
//  GoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 15/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var goalService = GoalService.shared
    var goal: Goal
    @State var isSubGoalsListPresented = false
    @State var isEditingMode = false
    @State var isShowingDeleteAlert = false
    
    @State var updatedImportance: String = Importance.none.description
    @State var updatedTitle: String = ""
    @State var updatedNote: String = ""
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40.0) {
                    
                    GoalHeaderView(goal: goal, isEditingMode: self.$isEditingMode, updatedTitle: self.$updatedTitle, updatedNote: self.$updatedNote)

                    if self.goal.dueDate != nil{
                        HStack {
                            Text("Deadline")
                            Spacer()
                            Text("\(self.goal.dueDate!, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.trailing, 5)
                        }
                        .modifier(SmallCell())
                    }
                    
                    ImportanceCard(goal: goal, isEditingMode: self.$isEditingMode, updatedImportance: self.$updatedImportance)

                    if goal.isDecomposed {
                        Button(action: { self.isSubGoalsListPresented = true }) {
                            HStack {
                                Text("Sub Goals")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .modifier(SmallCell())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: self.$isSubGoalsListPresented) {
                            SubGoalsList(goal: self.goal)
                        }
                    }
                    
                    HStack {
                        Button(action: { if !self.isSubGoalsListPresented { self.isShowingDeleteAlert = true } } ) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete the goal")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                        }
                    }
                    .modifier(SmallCell())
                    .alert(isPresented: self.$isShowingDeleteAlert) {
                        Alert(title: Text("Are you sure you want to delete this goal?"),
                              message: Text(self.goal.isDecomposed ? "All the Sub Goals of this goal will be deleted also" : ""),
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
                            Button(action: { self.saveGoal(goal: self.goal) }) {
                                Text("Save")
                            }
                        }else if !self.isEditingMode && !self.isSubGoalsListPresented{
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
            LoadingView(isLoading: self.$isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
        
        }

    func deleteGoal(){
        isLoading = true
        self.goalService.deleteGoal(goal: self.goal) { (result) in
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
    
    func saveGoal(goal: Goal) {
        isLoading = true
        var goalCopy = goal
        
        if goalCopy.importance?.description != self.updatedImportance && updatedImportance != Importance.none.description {
            goalCopy.importance = Goal.stringToImportance(importance: self.updatedImportance)
        }
        if goalCopy.title != self.updatedTitle && !updatedTitle.isEmpty {
            goalCopy.title = self.updatedTitle
        }
        if goalCopy.note != self.updatedNote {
            goalCopy.note = self.updatedNote
        }
        
        goalService.updateGoal(goal: goalCopy) { (result) in
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

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(goal: .dummy)
    }
}
