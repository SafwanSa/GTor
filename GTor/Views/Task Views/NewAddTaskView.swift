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
    var notificationService = NotificationService.shared

    @Environment(\.presentationMode) private var presentationMode
    @State var task = Task.dummy
    @State var deadline = Date()
    @State var remindMeAt = Date()
    
    @State var isHavingDeadline = false
    @State var isCalendarPresented = false
    @State var isLinkedGoalsPresented = false
    @State var isRemindMe = false
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        TextField(NSLocalizedString("title", comment: ""), text: $task.title)
                        TextField(NSLocalizedString("noteOptional", comment: ""), text: $task.note)
                    }
                    
                    Section {
                        Picker(selection: $task.importance, label: Text(NSLocalizedString("importance", comment: ""))) {
                            ForEach(Priority.allCases.filter { $0 != .none }, id: \.self) { importance in
                                Text(NSLocalizedString(importance.rawValue.lowercased(), comment: ""))
                            }
                        }
                    }
                    
                    Section(footer: Text(NSLocalizedString("explainLinkedGoals", comment: ""))) {
                        HStack {
                            Text(NSLocalizedString("linkedGoals", comment: ""))
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
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text(NSLocalizedString("deadline", comment: ""))
                        }
                        if isHavingDeadline {
                            Button(action: { self.isCalendarPresented = true }) {
                                HStack {
                                    Text(NSLocalizedString("selectADeadline", comment: ""))
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
                    
                    if isHavingDeadline {
                        Section {
                            Toggle(isOn: $isRemindMe) {
                                Text(NSLocalizedString("remindMe", comment: ""))
                            }
                            if isRemindMe {
                                DatePicker(selection: $remindMeAt, displayedComponents: .hourAndMinute) {
                                    Text(NSLocalizedString("at", comment: ""))
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("\(NSLocalizedString("addTask", comment: ""))")
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("cancel", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                    ,trailing:
                    Button(action: createTask) {
                        Text(NSLocalizedString("add", comment: ""))
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
        task.time = task.dueDate != nil ? remindMeAt : nil
        self.taskService.saveTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.notifyMe()
                self.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func notifyMe() {
        if isRemindMe && isHavingDeadline {
            self.notificationService.setNotification(on: self.deadline, at: self.remindMeAt, task: self.task)
        }
    }
}

struct NewAddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddTaskView()
    }
}
