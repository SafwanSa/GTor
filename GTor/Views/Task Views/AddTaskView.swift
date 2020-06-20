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
    @State var linkedGoals: [Goal] = []
    @State var isHavingDeadline = false
    @State var isLinkedGoalsPresented = false
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        TextField("Title", text: $title)
                        TextField("Note (Optional)", text: $note)
                    }
                    
                    Section {
                        Toggle(isOn: self.$isHavingDeadline) {
                            Text("Deadline")
                        }
                        if self.isHavingDeadline {
                            DatePicker(selection: self.$deadline, in: Date()..., displayedComponents: .date) {
                                Text("\(self.deadline, formatter: dateFormatter)")
                            }
                        }
                    }
                    
                    
                    Section {
                        HStack {
                            Text("Linked Goals")
                            Spacer()
                            Button(action: { self.isLinkedGoalsPresented = true }) {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                        }
                        .sheet(isPresented: $isLinkedGoalsPresented) {
                            LinkedGoalsView(selectedGoals: self.$linkedGoals)
                        }
                        ForEach(linkedGoals) { goal in
                            Text(goal.title)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("Add Task")
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                    }
                    ,trailing:
                    Button(action: createTask ) {
                        Text("Done")
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
        let task = Task(uid: self.userService.user.uid, title: title, note: note, dueDate: deadline, satisfaction: 0, isSatisfied: false, linkedGoals: linkedGoals)
        self.taskService.saveTask(task: task) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = "Successfully added"
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
