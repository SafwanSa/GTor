//
//  AddSubGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AddSubGoalView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var goalService: GoalService
    
    let importances = ["Very Important", "Important", "Not Important"]
    
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var importance: String = Importance.none.description
    @State var selectedImportanceIndex = -1
    
    @State var isHavingDeadline = false
    @State var isHavingSubgoals = true
    @State var alertMessage = "None"
    @Binding var isAddedGoalPresented: Bool
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
                    Toggle(isOn: self.$isHavingSubgoals) {
                        Text("Allow Sub Goals")
                    }
                }
                
                if !self.isHavingSubgoals {
                    Section {
                        HStack {
                            Text("Importance")
                            Spacer()
                            TextFieldWithPickerAsInputView(data: self.importances, placeholder: "Importance", selectionIndex: self.$selectedImportanceIndex, text: self.$importance)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationBarItems(leading:
                Button(action: { self.isAddedGoalPresented = false }) {
                    Text("Cancel")
                }
                ,trailing:
                Button(action: { self.addGoal()}) {
                    Text("Done")
                }
            )
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("Add Goal")
        }
    }
    
       func addGoal() {
        if self.isHavingSubgoals { self.importance = Importance.none.description }
        let goal = Goal(uid: self.userService.user.uid, title: self.title, note: self.note, isSubGoal: true, importance: Goal.stringToImportance(importance: self.importance), satisfaction: 0, dueDate: self.deadline, subGoals: [], isDecomposed: self.isHavingSubgoals)
           
        self.goal.subGoals.append(goal)
        
        
        }

}

struct _AddSubGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubGoalView(isAddedGoalPresented: .constant(true))
    }
}
