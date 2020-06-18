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
    var task: Task
    @State var updatedTitle = ""
    @State var updatedNote = ""
    @State var satisfaction = ""
    
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    
    var body: some View {
        ZStack {
            List {
                Section {
                    TextField(task.title, text: $updatedTitle)
                    TextField(task.note ?? "Note (Optional)", text: $updatedNote)
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
                        Text(linkedGoal.title ?? "")
                    }
                }

                
                Section {
                    HStack {
                        Text("Done")
                        Spacer()
                        TextField("100%", text: $satisfaction)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Button(action:  deleteTask ) {
                    Text("Delete Task")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Edit Task", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { /*Save*/ }) {
                    Text("Done")
                }
            )
        LoadingView(isLoading: self.$isLoading)
            }
            .alert(isPresented: self.$isShowingAlert) {
                Alert(title: Text(self.alertMessage))
            }
    }
    
    func deleteTask(){
        
        isLoading = true
        self.taskService.deleteTask(task: self.task) { (result) in
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
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .dummy)
    }
}
