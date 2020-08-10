//
//  NewAddTaskView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct NewAddTaskView: View {
    @ObservedObject var taskService = TaskService.shared
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var task = Task.dummy
    @State var deadline = Date()
    
    @State var isHavingDeadline = false
    @State var isCalendarPresented = false
    @State var isLinkedGoalsPresented = false
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        TextField(NSLocalizedString("Title", comment: ""), text: $task.title)
                        TextField(NSLocalizedString("Note (Optional)", comment: ""), text: $task.note)
                    }
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text(NSLocalizedString("Deadline", comment: ""))
                        }
                        if isHavingDeadline {
                            Button(action: { self.isCalendarPresented = true }) {
                                HStack {
                                    Text(NSLocalizedString("Select a deadline", comment: ""))
                                        .foregroundColor(Color("Button"))
                                    Spacer()
                                    Text("\(self.deadline, formatter: dateFormatter2)")
                                }
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .sheet(isPresented: $isCalendarPresented) {
                        GTorCalendarView(date: self.$deadline)
                    }
                    
                    
                    Section {
                        Picker(selection: $task.importance, label: Text(NSLocalizedString("Importance", comment: ""))) {
                            ForEach(Priority.allCases.filter { $0 != .none }, id: \.self) { importance in
                                Text(importance.rawValue)
                            }
                        }
                    }
                    
                    Section(footer: Text(NSLocalizedString("You can link your task to some of your goals, and these goals will progress if you accomplish the task that is linked to them. ", comment: ""))) {
                        HStack {
                            Text(NSLocalizedString("Linked Goals", comment: ""))
                            Spacer()
                            Button(action: { self.isLinkedGoalsPresented = true }) {
                                Image(systemName: "plus")
                                    .foregroundColor(Color("Button"))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        ForEach(goalService.goals.filter {self.task.linkedGoalsIds.contains($0.id)}) { goal in
                            Text(goal.title)
                        }
                    }
                    .sheet(isPresented: $isLinkedGoalsPresented) {
                        LinkedGoalsView(selectedGoals: self.$task.linkedGoalsIds)
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("\(NSLocalizedString("Add Task", comment: ""))")
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("Cancel", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                    ,trailing:
                    Button(action: createTask) {
                        Text(NSLocalizedString("Add", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                )
            }
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
    
    func createTask() {
        isLoading = true
        task.id = UUID()
        task.dueDate = isHavingDeadline ? deadline : nil
        self.taskService.saveTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewAddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddTaskView()
    }
}
