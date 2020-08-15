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
    @Environment(\.presentationMode) private var presentationMode
    @Binding var mainGoal: Goal
    @State var goal: Goal = .dummy
    @State var goalCopy = Goal.dummy
    @State var isEditingMode = false
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    var isShowingSave: Bool {
        !self.goalCopy.title.isEmpty && (self.goal.title != self.goalCopy.title || self.goal.note != self.goalCopy.note || self.goalCopy.importance != self.goal.importance)
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    GoalHeaderView(goal: $goalCopy, isEditingMode: $isEditingMode)
                }
                
                if goal.dueDate != nil{
                    Section {
                        HStack {
                            Text("deadline")
                            Spacer()
                            Text("\(goal.dueDate!, formatter: dateFormatter)")
                                .foregroundColor(.secondary)
                                .padding(.trailing, 5)
                        }
                    }
                }
                
                
                Section {
                    if goalCopy.isDecomposed {
                        if self.goalService.getSubGoals(mainGoal: goalCopy).count == 0 {
                            HStack {
                                Text("importance")
                                Spacer()
                                Image(systemName: "exclamationmark.square")
                                Text("Add Sub Goals")
                            }
                        }else {
                            HStack {
                                Text("importance")
                                Spacer()
                                Text(goalCopy.importance.rawValue)
                            }
                        }
                    }else {
                        if self.isEditingMode {
                            ImportancePicker(goal: $goal)
                        }else {
                            HStack {
                                Text("importance")
                                Spacer()
                                Text(goal.importance.rawValue)
                            }
                        }
                    }
                }
                
                
                if goal.isDecomposed {
                    Section {
                        NavigationLink(destination: SubGoalsList(goal: $goal)) {
                            Text("SubGoals")
                        }
                    }
                    
                }
                
                Section {
                    HStack {
                        Button(action: { self.isShowingDeleteAlert = true } ) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete the goal")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                        }
                    }
                     .alert(isPresented: $isShowingDeleteAlert) {
                        Alert(title: Text("areYouSureWantDeleteGoal"),
                              message: Text(self.goalCopy.isDecomposed ? "allSubGoalsWillBeDeleted" : ""),
                              primaryButton: .default(Text("cancel")),
                              secondaryButton: .destructive(Text("delete"), action: {
                                self.goal.isSubGoal ? self.deleteSubGoal() :self.deleteGoal()
                              }))
                    }
                }
                
                
            }
            .onAppear {
                if !self.goal.isSubGoal && self.goalCopy == .dummy {
                    self.goalCopy = self.goal
                }else{
                    if self.goalCopy == .dummy {
                        self.goalCopy = self.goal
                    }else {
                        if self.goalCopy.importance == self.goal.importance { self.goalCopy = self.goal }
                    }
                }
            }
            .animation(.spring())
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(goal.isSubGoal ? "subGoal" :"goal")
            .navigationBarItems(leading:
                Button(action: { self.isEditingMode = false ; self.goal.importance = self.goalCopy.importance ; self.goalCopy = self.goal }) {
                    Text("cancel")
                }.opacity(isEditingMode ? 1 : 0)
                , trailing:
                Group {
                    if isEditingMode {
                        Button(action: { self.goal.isSubGoal ? self.saveSubGoal() : self.saveGoal()}) {
                            Text("save")
                        }.opacity(isShowingSave ? 1 : 0)
                    }else if !isEditingMode{
                        Button(action: { self.isEditingMode = true }) {
                            Text("edit")
                        }
                    }
                }
            )
            .navigationBarBackButtonHidden(self.isEditingMode)
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
    
    func deleteSubGoal(){
        isLoading = true
        goalService.deleteGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                CalcService.shared.calcImportance(for: self.mainGoal) { (result) in
                    switch result {
                    case .failure(let error):
                        self.isLoading = false
                        self.isShowingAlert = true
                        self.alertMessage = error.localizedDescription
                    case .success(let goal):
                        self.mainGoal = goal
                        for task in TaskService.shared.tasks.filter({ $0.linkedGoalsIds.contains(self.goal.id) }) {
                            let index = TaskService.shared.tasks.firstIndex { $0.id == task.id }!
                            TaskService.shared.tasks[index].importance = CalcService.shared.calcImportance(from: task.linkedGoalsIds)
                        }
                        self.isLoading = false
                        self.isEditingMode = false
                    }
                }
            }
        }
    }
    
    func saveSubGoal() {
        isLoading = true
        goalService.saveGoal(goal: self.goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
                self.isEditingMode = false
            case .success(()):
                CalcService.shared.calcImportance(for: self.mainGoal) { (result) in
                    switch result {
                    case .failure(let error):
                        self.isLoading = false
                        self.isShowingAlert = true
                        self.alertMessage = error.localizedDescription
                    case .success(let goal):
                        self.mainGoal = goal
                        for task in TaskService.shared.tasks.filter({ $0.linkedGoalsIds.contains(self.goal.id) }) {
                            let index = TaskService.shared.tasks.firstIndex { $0.id == task.id }!
                            TaskService.shared.tasks[index].importance = CalcService.shared.calcImportance(from: task.linkedGoalsIds)
                        }
                        self.isLoading = false
                        self.isEditingMode = false
                        self.isShowingAlert = true
                        self.alertMessage = "Successfully saved"
                    }
                }
            }
        }
    }
    
    func deleteGoal(){
        isLoading = true
        goalService.deleteGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                for goal in self.goalService.getSubGoals(mainGoal: self.goal) {
                    self.goalService.deleteGoal(goal: goal) {_ in}
                }
                for task in TaskService.shared.tasks.filter({ $0.linkedGoalsIds.contains(self.goal.id) }) {
                    let index = TaskService.shared.tasks.firstIndex { $0.id == task.id }!
                    TaskService.shared.tasks[index].importance = CalcService.shared.calcImportance(from: task.linkedGoalsIds)
                }
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = "Successfully deleted"
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func saveGoal() {
        isLoading = true
        let importance = self.goal.importance
        self.goal = self.goalCopy
        self.goal.importance = importance
        goalService.saveGoal(goal: self.goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
                self.isEditingMode = false
            case .success(()):
                for task in TaskService.shared.tasks.filter({ $0.linkedGoalsIds.contains(self.goal.id) }) {
                    let index = TaskService.shared.tasks.firstIndex { $0.id == task.id }!
                    TaskService.shared.tasks[index].importance = CalcService.shared.calcImportance(from: task.linkedGoalsIds)
                }
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
        SubGoalView(mainGoal: .constant(.dummy), goal: .dummy)
    }
}
