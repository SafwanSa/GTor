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
        (taskCopy.title != task.title || taskCopy.note != task.note || taskCopy.dueDate != task.dueDate || taskCopy.importance != task.importance || String(task.satisfaction) != updatedSatisfaction)
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40.0) {
                    NewTaskHeaderView(task: $taskCopy)
                    
                    NewImportanceCardView(task: $taskCopy)
                    
                    NewSatisfactionCardView(updatedSatisfaction: $updatedSatisfaction)
                    
                    DateCardView(date: $task.dueDate)
                    
                    if !task.linkedGoalsIds.isEmpty { NewLinkedGoalsCardView(task: task) }
                    
                    DeleteTaskCardView(task: $task, isLoading: $isLoading)
                }
                .padding()
            }
            .navigationBarTitle("\(NSLocalizedString("task", comment: ""))", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: saveGoal) {
                    Text(NSLocalizedString("save", comment: ""))
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
            self.alertMessage = NSLocalizedString("invalidSatisfaction", comment: "")
            return
        }
        if !taskCopy.isSatisfied && taskCopy.satisfaction != 0{ taskCopy.isSatisfied = true }
        taskCopy.satisfaction = Double(updatedSatisfaction)!
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
                    Text(NSLocalizedString("edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTitleEditor) {
                    TextEditorView(title: NSLocalizedString("editTitle", comment: ""), text: self.$task.title)
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
            
            HStack {
                Text(task.note.isEmpty ? NSLocalizedString("emptyNote", comment: "") : task.note)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: { self.isShowingNoteEditor = true }) {
                    Text(NSLocalizedString("edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingNoteEditor) {
                    TextEditorView(title: NSLocalizedString("editNote", comment: ""), text: self.$task.note)
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
    var notificationService = NotificationService.shared
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
                    Text(NSLocalizedString("deleteTask", comment: ""))
                    Spacer()
                }
            ), backgroundColor: Color(.white), foregroundColor: Color("Primary"), action: { self.isShowingDeleteAlert = true })
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text(NSLocalizedString("areYouSureWantDeleteTask", comment: "")),
                  primaryButton: .default(Text(NSLocalizedString("cancel", comment: ""))),
                  secondaryButton: .destructive(Text(NSLocalizedString("delete", comment: "")), action: deleteTask))
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
                self.notificationService.deleteNotification(taskUID: self.task.id)
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
                Text(NSLocalizedString("complete", comment: ""))
                Spacer()
                Text(updatedSatisfaction)
                Button(action: { self.isShowingTextEditor = true }) {
                    Text(NSLocalizedString("edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTextEditor) {
                    TextEditorView(title: NSLocalizedString("editSatisfaction", comment: ""), text: self.$updatedSatisfaction)
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
                Text(NSLocalizedString("importance", comment: ""))
                Spacer()
                Text(NSLocalizedString(task.importance.rawValue.lowercased(), comment: ""))
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color("Secondry").opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .elevation()
                Button(action: { self.isShowingEdit = true }) {
                    Text(NSLocalizedString("edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .opacity(0)//TODO
            }
        ))
    }
}

struct NewLinkedGoalsCardView: View {
    @State var isExpanded = false
    var task: Task
    
    var body: some View {
        VStack {
            NewCardView(content: AnyView(
                Button(action: { self.isExpanded.toggle() }) {
                    HStack{
                        Text(NSLocalizedString("linkedGoals", comment: ""))
                        Spacer()
                        Image(systemName: NSLocalizedString("chevron", comment: ""))
                            .font(.system(size: 13))
                            .frame(width: 15)
                            .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
                            .animation(.linear)
                    }
                .contentShape(Rectangle())
                }
            .buttonStyle(PlainButtonStyle())
            ))
            
            VStack {
                if isExpanded {
                    ForEach(TaskService.shared.getLinkedGoals(task: task)) { goal in
                        NewGoalCardView(goal: goal)
                            .padding()
                    }
                }
            }
        }
        .animation(.easeInOut)
    }
}
