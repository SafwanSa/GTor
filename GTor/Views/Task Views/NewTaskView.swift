//
//  NewTaskView.swift
//  GTor
//
//  Created by Safwan Saigh on 29/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct NewTaskView: View {
    @ObservedObject var taskService = TaskService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var task: Task = .dummy
    @State var taskCopy = Task.dummy
    @State var updatedSatisfaction = ""
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isShowingAlert = false
    @State var isLoading: Bool = false
    
    var isShowingSave: Bool {
        (taskCopy.title != task.title || taskCopy.note != task.note || taskCopy.dueDate != task.dueDate || taskCopy.satisfaction != task.satisfaction || taskCopy.importance != task.importance)
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40.0) {
                    NewTaskHeaderView(task: $taskCopy)
                    
                    NewImportanceCardView(task: $taskCopy)
                    
                    NewSatisfactionCardView(updatedSatisfaction: $updatedSatisfaction)
                    
                    DateCardView(date: $task.dueDate)
                    
                    DeleteTaskCardView(task: $task, isLoading: $isLoading)
                }
                .padding()
            }
            .navigationBarTitle("Goal", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: saveGoal) {
                    Text("Save")
                        .font(.callout)
                        .foregroundColor(Color("Button"))
                }
                .opacity(isShowingSave ? 1 : 0)
            )
            
            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            self.taskCopy = self.task
            self.updatedSatisfaction = String(self.task.satisfaction)
        }
    }
    
    func saveGoal() {
        isLoading = true
        if Double(updatedSatisfaction) == nil {
            self.isLoading = false
            self.isShowingAlert = true
            self.alertMessage = "Invalid satisfaction."
            return
        }
        task.satisfaction = Double(updatedSatisfaction)!
        self.task = self.taskCopy
        taskService.saveTask(task: self.task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
            }
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}

struct NewTaskHeaderView: View {
    @Binding var task: Task
    @State var isShowingTitleEditor = false
    @State var isShowingNoteEditor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            HStack {
                Text(task.title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: { self.isShowingTitleEditor = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTitleEditor) {
                    TextEditorView(title: "Edit Title", text: self.$task.title)
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
            
            HStack {
                Text(task.note.isEmpty ? "Empty Note" : task.note)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: { self.isShowingNoteEditor = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingNoteEditor) {
                    TextEditorView(title: "Edit Note", text: self.$task.note)
                }
            }
        }
        .foregroundColor(Color("Primary"))
        .padding(.vertical)
        .padding(.horizontal, 22)
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .elevation()
    }
}
struct DeleteTaskCardView: View {
    @ObservedObject var taskService = TaskService.shared
    @Environment(\.presentationMode) private var presentationMode
    @Binding var task: Task
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isShowingAlert = false
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            GTorButton(content: AnyView(
                HStack(spacing: 8.0) {
                    Image(systemName: "trash")
                    Text("Delete Task")
                    Spacer()
                }
            ), backgroundColor: Color(.white), foregroundColor: Color("Primary"), action: { self.isShowingDeleteAlert = true })
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text("Are you sure you want to delete this task?"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(Text("Delete"), action: deleteTask))
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
}

struct NewSatisfactionCardView: View {
    @State var isShowingTextEditor: Bool = false
    @Binding var updatedSatisfaction: String
    
    var body: some View {
        NewCardView(content: AnyView(
            HStack {
                Text("Complete")
                Spacer()
                Text(updatedSatisfaction)
                Button(action: { self.isShowingTextEditor = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTextEditor) {
                    TextEditorView(title: "Edit Satisfaction", text: self.$updatedSatisfaction)
                }
            }
        ))
    }
}

struct NewImportanceCardView: View {
    @Binding var task: Task
    @State var isShowingEdit = false
    
    var body: some View {
        NewCardView(content: AnyView(
            HStack {
                Text("Importance")
                Spacer()
                Text(task.importance.rawValue)
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color("Secondry").opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .elevation()
                Button(action: { self.isShowingEdit = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
            }
        ))
    }
}
