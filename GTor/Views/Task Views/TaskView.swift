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
                Section {
                    TextField(task.title, text: $task.title)
                    TextField(task.note.isEmpty ? "Note (Optional)" : task.note, text: $task.note)
                }
                
                if task.dueDate != nil {
                    Section {
                        HStack {
                            Text("Due")
                            Spacer()
                            Text("\(task.dueDate!, formatter: dateFormatter)")
                        }
                    }
                }
                
                Section(header: Text("Linked Goals")) {
                    ForEach(task.linkedGoals!) { linkedGoal in
                        Text(linkedGoal.title)
                    }
                }
                
                
                Section {
                    HStack {
                        Text("Done")
                        Spacer()
                        TextField("\(task.satisfaction*100)%", text: $updatedSatisfaction)
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
            .navigationBarTitle("Edit Task", displayMode: .inline)
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
        if !updatedSatisfaction.isEmpty { task.satisfaction = Double(updatedSatisfaction)! }
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
