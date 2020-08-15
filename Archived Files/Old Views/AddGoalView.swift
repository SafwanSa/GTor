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
    @ObservedObject var categoryService = CategoryService.shared

    @Environment(\.presentationMode) private var presentationMode

    @State var goal: Goal = .empty
    @State var deadline = Date()
    
    @State var isHavingDeadline = false
    @State var isDecomposed = true
    @State var isSelectCategoryExpanded = false
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    @State var isEditCategoriesPresented = false
    
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    SelectCategoryView(isCategoryPressed: $isSelectCategoryExpanded, selectedCategories: self.$goal.categories, categories: self.$categoryService.categories)
                    
                    Section {
                        TextField("title", text: $goal.title)
                        TextField("noteOptional", text: $goal.note)
                    }
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text("deadline")
                        }
                        if isHavingDeadline {
                            DatePicker(selection: $deadline, in: Date()..., displayedComponents: .date) {
                                Text("\(deadline, formatter: dateFormatter)")
                            }
                        }
                    }
                    
                    Section {
                        Toggle(isOn: $isDecomposed) {
                            Text("subGoals")
                        }
                    }
                    
                    if !self.isDecomposed {
                        Section {
                            Picker(selection: $goal.importance, label: Text("importance")) {
                                ForEach(Priority.allCases.filter { $0 != .none }, id: \.self) { importance in
                                    Text(importance.rawValue)
                                }
                            }
                        }
                    }
                }
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text("cancel")
                    }
                    ,trailing:
                    Button(action: { self.createGoal()}) {
                        Text("done")
                    }
                )
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .navigationBarTitle("addGoal")
            }
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(alertMessage))
        }
    }
    
       func createGoal() {
        isLoading = true
        self.goal.id = UUID()
        if isDecomposed { self.goal.importance = Priority.none }
        self.goal.dueDate = isHavingDeadline ? deadline : nil
        self.goal.isDecomposed = self.isDecomposed
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

