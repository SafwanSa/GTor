//
//  NewAddGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 26/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


import SwiftUI
import UIKit

struct NewAddGoalView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @ObservedObject var categoryService = CategoryService.shared
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var goal: Goal = .empty
    @State var deadline = Date()
    
    @State var isHavingDeadline = false
    @State var isSelectCategoryExpanded = true
    
    @State var isCalendarPresented = false
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    @State var selectedCategoriesIds: Set<UUID> = []
    var selectedCategories: [Category] {
        categoryService.categories.filter { self.selectedCategoriesIds.contains($0.id) }
    }
    @Binding var mainGoal: Goal
    var body: some View {
        ZStack {
            NavigationView {
                List(selection: $selectedCategoriesIds) {
                    if !goal.isSubGoal {
                        Section(header: Text(isSelectCategoryExpanded ? NSLocalizedString("Press to fold", comment: "Press to open") : NSLocalizedString("Press to open", comment: ""))) {
                            HStack {
                                Image(systemName: "tag")
                                Text(selectedCategoriesIds.isEmpty ? NSLocalizedString("Select Tags", comment: "") : selectedCategories.map { $0.name }.joined(separator: ", "))
                            }
                            .onTapGesture {
                                self.isSelectCategoryExpanded.toggle()
                            }
                            
                            if isSelectCategoryExpanded {
                                ForEach(self.categoryService.categories) { category in
                                    Text(category.name)
                                        .font(.system(size: 12))
                                        .padding(7)
                                        .background(Color(GTColor.init(rawValue: category.colorId ?? 0)!.color).opacity(0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                    }
                    
                    Section {
                        TextField(NSLocalizedString("Title", comment: ""), text: $goal.title)
                        TextField(NSLocalizedString("Note (Optional)", comment: ""), text: $goal.note)
                    }
                    
                    Section {
                        Toggle(isOn: $isHavingDeadline) {
                            Text(NSLocalizedString("Deadline", comment: ""))
                        }
                        if isHavingDeadline {
                            Button(action: { self.isCalendarPresented = true }) {
                            HStack {
                                Text(NSLocalizedString("Select a deadline", comment: ""))
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
                    
                    if !goal.isSubGoal {
                        Section {
                            Toggle(isOn: $goal.isDecomposed) {
                                Text(NSLocalizedString("Sub Goals", comment: ""))
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(EditMode.active))
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("Cancel", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                    ,trailing:
                    Button(action: !goal.isSubGoal ? createGoal : addGoal) {
                        Text(NSLocalizedString("add", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                )
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .navigationBarTitle(goal.isSubGoal ? NSLocalizedString("Add Sub-Goal", comment: "") : NSLocalizedString("Add Goal", comment: ""))
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
        self.goal.categories = selectedCategories
        self.goal.dueDate = isHavingDeadline ? deadline : nil
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
    
    func addGoal() {
        isLoading = true
        self.goal.id = UUID()
        self.goal.dueDate = isHavingDeadline ? deadline : nil
        self.goal.mid = self.mainGoal.id
        goalService.saveGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                CalcService.shared.calcProgress(for: self.mainGoal)
                self.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


struct NewAddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddGoalView(mainGoal: .constant(.dummy))
    }
}

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
