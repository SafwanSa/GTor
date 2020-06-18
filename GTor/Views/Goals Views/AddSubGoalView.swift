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
    let importances = ["Very Important", "Important", "Not Important"]
    
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var importance: String = Importance.none.description
    @State var selectedImportanceIndex = -1
    
    @State var isHavingDeadline = false
    @State var goal: Goal = .dummy
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
                        HStack {
                            TextFieldWithPickerAsInputView(data: importances, placeholder: "Importance", selectionIndex: $selectedImportanceIndex, text: $importance)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                    }
                    ,trailing:
                    Button(action: { self.addGoal()}) {
                        Text("Done")
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
        let subGoal = Goal(uid: AuthService.userId!, title: self.title, note: self.note, isSubGoal: true, importance: Goal.stringToImportance(importance: self.importance), satisfaction: 0,
                           dueDate: self.isHavingDeadline ? self.deadline : nil,
                           categories: [],
                           isDecomposed: false,
                           tasks: [])
        goalService.validateGoal(goal: subGoal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.goal.subGoals?.append(subGoal)
                self.goalService.updateSubGoals(goal: self.goal) { (result) in
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
    }
}

struct _AddSubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubGoalView()
    }
}
