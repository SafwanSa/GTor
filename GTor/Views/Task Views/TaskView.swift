//
//  TaskView.swift
//  GTor
//
//  Created by Safwan Saigh on 11/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var taskService = TaskService.shared
    @ObservedObject var goalService = GoalService.shared
    @State var task: Task
    @State var taskCopy = Task.dummy
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    @State var updatedSatisfaction = ""
    @State var isEditingMode = false
    @State var isShowingDeleteAlert = false
    
    var isShowingSave: Bool {
        return !self.taskCopy.title.isEmpty && (self.task.title != self.taskCopy.title || self.task.note != self.taskCopy.note || self.taskCopy.satisfaction != Double(updatedSatisfaction)) && !updatedSatisfaction.isEmpty && Double(updatedSatisfaction) != nil
    }
    var body: some View {
        ZStack {
            List {
                Section {
                    TaskHeaderView(task: self.$taskCopy, isEditingMode: $isEditingMode)
                }
                
                if taskCopy.dueDate != nil {
                    Section {
                        HStack {
                            Text("Due")
                            Spacer()
                            Text("\(taskCopy.dueDate!, formatter: dateFormatter)")
                        }
                    }
                }
                
                if !goalService.goals.filter { self.taskCopy.linkedGoalsIds.contains($0.id) }.isEmpty {
                    Section(header: Text("Linked Goals")) {
                        ForEach(taskService.getLinkedGoals(task: self.taskCopy)) { linkedGoal in
                            Text(linkedGoal.title)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Importance")
                        Spacer()
                        Text(self.taskCopy.importance.rawValue)
                    }
                }
                
                Section {
                    HStack {
                        Text("Satisfaction")
                        Spacer()
                        if isEditingMode {
                            TextField("\(String(format: "%.2f", taskCopy.satisfaction))%", text: $updatedSatisfaction)
                            .keyboardType(.asciiCapableNumberPad)
                            .multilineTextAlignment(.trailing)
                            
                        }else {
                            Text("\(String(format: "%.2f", taskCopy.satisfaction))%")
                        }
                    }
                }
                
                Section {
                    Button(action: { self.isShowingDeleteAlert = true } ) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete task")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(GroupedListStyle())
            .animation(.spring())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Task", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: { self.isEditingMode = false ; self.taskCopy = self.task ; self.updatedSatisfaction = String(self.task.satisfaction)}) {
                    Text("Cancel")
                }.opacity(isEditingMode ? 1 : 0)
                , trailing:
                Group {
                    if isEditingMode {
                        Button(action: saveTask) {
                            Text("Save")
                        }.opacity(isShowingSave ? 1 : 0)
                    }else if !isEditingMode{
                        Button(action: { self.isEditingMode = true }) {
                            Text("Edit")
                        }
                    }
                }
            )
            .navigationBarBackButtonHidden(self.isEditingMode)
            LoadingView(isLoading: self.$isLoading)
        }
        .onAppear {
            self.taskCopy = self.task
            self.updatedSatisfaction = String(self.task.satisfaction)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text("Are you sure you want to delete this task?"),
            primaryButton: .default(Text("Cancel")),
            secondaryButton: .destructive(Text("Delete"), action: {
                self.deleteTask()
            }))
        }
    }
    
    func deleteTask() {
        isLoading = true
        self.taskService.deleteTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                CalcService.shared.calcProgress(from: self.task)
                self.isLoading = false
            }
        }
    }
    
    func saveTask() {
        task = taskCopy
        isLoading = true
        if Double(updatedSatisfaction) == nil {
            self.isLoading = false
            self.isShowingAlert = true
            self.alertMessage = "Invalid satisfaction."
            return
        }
        task.satisfaction = Double(updatedSatisfaction)!
        taskService.saveTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
                self.updatedSatisfaction = String(self.taskCopy.satisfaction)
            case .success(()):
                self.isLoading = false
                self.isShowingAlert = true
                self.isEditingMode = false
                self.alertMessage = "Successfully Saved"
            }
        }
    }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .dummy)
    }
}
