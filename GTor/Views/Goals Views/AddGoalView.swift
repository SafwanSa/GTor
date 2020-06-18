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
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var selectedImportance = Importance.none
    @State var selectedCategories: [Category] = []
    
    @State var isHavingDeadline = false
    @State var isDecomposed = true
    @State var isSelectCategoryExpanded = false
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false

    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    SelectCategoryView(isCategoryPressed: $isSelectCategoryExpanded, selectedCategories: self.$selectedCategories, categories: $categories)
                    
                    Section {
                        TextField("Title", text: $title)
                        TextField("Note (Optional)", text: $note)
                    }
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text("Deadline")
                        }
                        if isHavingDeadline {
                            DatePicker(selection: $deadline, in: Date()..., displayedComponents: .date) {
                                Text("\(deadline, formatter: dateFormatter)")
                            }
                        }
                    }
                    
                    Section {
                        Toggle(isOn: $isDecomposed) {
                            Text("Sub Goals")
                        }
                    }
                    
                    if !self.isDecomposed {
                        Section {
                            Picker(selection: $selectedImportance, label: Text("Importance")) {
                                ForEach(Importance.allCases.filter { $0 != .none }, id: \.self) { importance in
                                    Text(importance.rawValue)
                                }
                            }
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
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(alertMessage))
        }
    }
    
       func createGoal() {
        isLoading = true
        if isDecomposed { self.selectedImportance = Importance.none }
        let goal = Goal(uid: userService.user.uid, title: title, note: note, isSubGoal: false , importance: selectedImportance, satisfaction: 0,
                        dueDate: isHavingDeadline ? deadline : nil, categories: selectedCategories,
                        subGoals: isDecomposed ? [] : nil, isDecomposed: isDecomposed,
                        tasks: [])
            goalService.saveGoal(goal: goal) { (result) in
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
