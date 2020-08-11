//
//  AddSubGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AddSubGoalView: View {
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var selectedImportance = Priority.none

    
    @State var isHavingDeadline = false
    @Binding var goal: Goal
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        TextField("title", text: $title)
                        TextField("noteOptional", text: $note)
                    }
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text("Add a deadline")
                        }
                        if isHavingDeadline {
                            DatePicker(selection: $deadline, in: Date()..., displayedComponents: .date) {
                                Text("\(self.deadline, formatter: dateFormatter)")
                            }
                        }
                    }
                    
                    Section {
                        
                        Picker(selection: $selectedImportance, label: Text("importance")) {
                            ForEach(Priority.allCases.filter { $0 != .none }, id: \.self) { importance in
                                Text(importance.rawValue)
                            }
                        }
                    }
                }
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("cancel")
                    }
                    ,trailing:
                    Button(action: { self.addGoal()}) {
                        Text("done")
                    }
                )
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .navigationBarTitle("Add Sub Goal")
            }
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
    
    func addGoal() {
        isLoading = true
        let goal = Goal(uid: UserService.shared.user.uid, title: self.title, note: self.note, isSubGoal: true, importance: selectedImportance, satisfaction: 0,
                           dueDate: self.isHavingDeadline ? self.deadline : nil,
                           categories: [],
                           isDecomposed: false,
                           mid: self.goal.id)
            goalService.saveGoal(goal: goal) { (result) in
             switch result {
             case .failure(let error):
                 self.isLoading = false
                 self.isShowingAlert = true
                 self.alertMessage = error.localizedDescription
             case .success(()):
                CalcService.shared.calcImportance(for: self.goal) { (result) in
                    switch result {
                    case .failure(let error):
                        self.isLoading = false
                        self.isShowingAlert = true
                        self.alertMessage = error.localizedDescription
                    case .success(let goal):
                        self.goal = goal
                        self.isLoading = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
             }
         }
    }
}

struct _AddSubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubGoalView(goal: .constant(.dummy))
    }
}
