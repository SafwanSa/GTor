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
    @State var task: Task
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    @State var updatedSatisfaction = ""
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Title")) {
                    TextField(task.title, text: $task.title)
                }
                .disabled(true)
                
                if task.isSatisfied && !task.note.isEmpty || !task.isSatisfied{
                    Section(header: Text("Note")) {
                        if task.isSatisfied { if !task.note.isEmpty { TextField(task.note, text: $task.note) } } else { TextField(task.note.isEmpty ? "Note (Optional)" : task.note, text: $task.note) }
                    }
                    .disabled(true)
                }

                
                if task.dueDate != nil {
                    Section(header: Text("Deadline")) {
                        HStack {
                            Text("Due")
                            Spacer()
                            Text("\(task.dueDate!, formatter: dateFormatter)")
                        }
                    }
                }
                
                if !task.linkedGoalsIds.isEmpty {
                    Section(header: Text("Linked Goals")) {
                        ForEach(GoalService.shared.goals.filter {self.task.linkedGoalsIds.contains($0.id)}) { linkedGoal in
                            Text(linkedGoal.title)
                        }
                    }
                }
                
                
                Section(header: Text("Satisfaction")) {
                    HStack {
                        Text("Done")
                        Spacer()
                        TextField("\(task.satisfaction)%", text: $updatedSatisfaction)
                            .keyboardType(.asciiCapableNumberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Button(action:  deleteTask ) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete task")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(task.isSatisfied ? "\(task.title)" : "Edit Task", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: saveTask) {
                    Text("Done")
                }
            )
            LoadingView(isLoading: self.$isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
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
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = "Successfully deleted"
            }
        }
    }
    
    func saveTask() {
        if !updatedSatisfaction.isEmpty {
            //            if updatedSatisfaction.last == "%" { updatedSatisfaction.removeLast() }
            task.satisfaction = Double(updatedSatisfaction)!
            //            updatedSatisfaction+="%"
        }
        isLoading = true
        taskService.saveTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
                self.isShowingAlert = true
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
