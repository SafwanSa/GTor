//
//  AddGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 16/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import UIKit

struct AddGoalView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode

    @State var categories = categoriesData//TODO bring this from db
    let importances = ["Very Important", "Important", "Not Important"]
    
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var importance: String = Importance.none.description
    @State var selectedImportanceIndex = -1
    @State var selectedCategories: [Category] = []
    
    @State var isHavingDeadline = false
    @State var isHavingSubgoals = true
    @State var isSelectCategoryExpanded = false
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false

    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    SelectCategoryView(isCategoryPressed: self.$isSelectCategoryExpanded, selectedCategories: self.$selectedCategories, categories: self.$categories)
                    
                    Section {
                        TextField("Title", text: self.$title)
                        TextField("Note (Optional)", text: self.$note)
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
                        Toggle(isOn: self.$isHavingSubgoals) {
                            Text("Sub Goals")
                        }
                    }
                    
                    if !self.isHavingSubgoals {
                        Section {
                                TextFieldWithPickerAsInputView(data: self.importances, placeholder: "Importance", selectionIndex: self.$selectedImportanceIndex, text: self.$importance)
                        }
                    }
                }
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                    }
                    ,trailing:
                    Button(action: { self.createGoal()}) {
                        Text("Done")
                    }
                )
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .navigationBarTitle("Add Goal")
            }
            LoadingView(isLoading: self.$isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
    
       func createGoal() {
        isLoading = true
        if self.isHavingSubgoals { self.importance = Importance.none.description }
        let goal = Goal(uid: self.userService.user.uid, title: self.title, note: self.note, isSubGoal: false , importance: Goal.stringToImportance(importance: self.importance), satisfaction: 0,
                        dueDate: self.isHavingDeadline ? self.deadline : nil, categories: self.selectedCategories,
                        subGoals: self.isHavingSubgoals ? [] : nil, isDecomposed: self.isHavingSubgoals,
                        tasks: [])
            self.goalService.saveGoal(goal: goal) { (result) in
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
 

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
    }
}


var categoriesData: [Category] = [
    .init(name: "Work"),
    .init(name: "Study"),
    .init(name: "Relationships"),
    .init(name: "Life")
]

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    return formatter
}

var dateFormatter2: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}
