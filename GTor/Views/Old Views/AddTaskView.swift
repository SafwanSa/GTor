//
//  AddTaskView.swift
//  GTor
//
//  Created by Safwan Saigh on 12/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskService = TaskService.shared
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var linkedGoalsIds: [UUID] = []
    @State var isHavingDeadline = false
    @State var isLinkedGoalsPresented = false
    @State var isHavingLinkedGoals = true
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    @State var selectedImportance = Priority.none
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        TextField("title", text: $title)
                        TextField("noteOptional", text: $note)
                    }
                    
                    Section {
                        Toggle(isOn: self.$isHavingDeadline) {
                            Text("deadline")
                        }
                        if self.isHavingDeadline {
                            DatePicker(selection: self.$deadline, in: Date()..., displayedComponents: .date) {
                                Text("\(self.deadline, formatter: dateFormatter)")
                            }
                        }
                    }
                    
                    
                    
                    Section {
                        Toggle(isOn: $isHavingLinkedGoals) {
                            Text("Add Linked Goals")
                        }
                        if isHavingLinkedGoals {
                            HStack {
                                Text("linkedGoals")
                                Spacer()
                                Button(action: { self.isLinkedGoalsPresented = true }) {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .sheet(isPresented: $isLinkedGoalsPresented) {
                                LinkedGoalsView(selectedGoals: self.$linkedGoalsIds)
                            }
                            ForEach(goalService.goals.filter {self.linkedGoalsIds.contains($0.id)}) { goal in
                                Text(goal.title)
                            }
                        }
                    }
                    
                    if !isHavingLinkedGoals {
                        Picker(selection: $selectedImportance, label: Text("importance")) {
                            ForEach(Priority.allCases.filter { $0 != .none }, id: \.self) { importance in
                                Text(importance.rawValue)
                            }
                        }
                    }
                    
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("addTask")
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("cancel")
                    }
                    ,trailing:
                    Button(action: createTask ) {
                        Text("done")
                    }
                )
            }
            LoadingView(isLoading: self.$isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
    
    func createTask() {
        isLoading = true
        if isHavingLinkedGoals && linkedGoalsIds.isEmpty {
            self.isLoading = false
            self.isShowingAlert = true
            self.alertMessage = "Please add linked goals"
            return
        }
        let task = Task(uid: self.userService.user.uid, title: title, note: note, dueDate: isHavingDeadline ? deadline : nil, satisfaction: 0, isSatisfied: false, linkedGoalsIds: isHavingLinkedGoals ? linkedGoalsIds : [], importance: linkedGoalsIds.isEmpty ? selectedImportance : CalcService.shared.calcImportance(from: linkedGoalsIds))

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

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
