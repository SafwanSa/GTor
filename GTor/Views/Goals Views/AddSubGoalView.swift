//
//  AddSubGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AddSubGoalView: View {
    @EnvironmentObject var goalService: GoalService
    @Environment(\.presentationMode) private var presentationMode
    let importances = ["Very Important", "Important", "Not Important"]
    
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var importance: String = Importance.none.description
    @State var selectedImportanceIndex = -1
    
    @State var isHavingDeadline = false
    @State var alertMessage = "None"
    @State var goal: Goal = .dummy
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Title", text: self.$title)
                    TextField("Note (Optional)", text: self.$note)
                }
                
                Section {
                    Toggle(isOn: self.$isHavingDeadline) {
                        Text("Add a deadline")
                    }
                    if self.isHavingDeadline {
                        DatePicker(selection: self.$deadline) {
                            Text("Deadline")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Importance")
                        Spacer()
                        TextFieldWithPickerAsInputView(data: self.importances, placeholder: "Importance", selectionIndex: self.$selectedImportanceIndex, text: self.$importance)
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
    }
    
    func addGoal() {
        let goal = Goal(uid: AuthService.userId, title: self.title, note: self.note, isSubGoal: true, importance: Goal.stringToImportance(importance: self.importance), satisfaction: 0,
                        dueDate: self.isHavingDeadline ? self.deadline : nil,
                        isDecomposed: false)
        self.goal.subGoals?.append(goal)
        self.goalService.addSubGoal(mainGoal: self.goal) { (result) in
            switch result {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.alertMessage = "Goal was sucssefully added"
                self.presentationMode.wrappedValue.dismiss()
            }
        }

        
        
    }
    
}

struct _AddSubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubGoalView()
    }
}
