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
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var goalService: GoalService
    
    @State var categories = categoriesData//TODO bring this from db
    var importances = ["Very Important", "Important", "Not Important"]
    
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var importance: String = Importance.none.description
    @State var selectedImportanceIndex = -1
    @State var selectedCategories: [Category] = []
    
    @State var isHavingDeadline = false
    @State var isHavingSubgoals = true
    @State var isCategoryPressed = false
    @State var alertMessage = "None"
    @Binding var isAddGoalSelceted: Bool
    
    var body: some View {
        NavigationView {
            List {
                SelectCategoryView(isCategoryPressed: self.$isCategoryPressed, selectedCategories: self.$selectedCategories, categories: self.$categories)
                
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
                            TextFieldWithPickerAsInputView(data: self.importances, placeholder: "Importance", selectionIndex: self.$selectedImportanceIndex, text: self.$importance)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    Text(self.alertMessage)
                }
            }
            .navigationBarItems(leading:
                Button(action: { self.isAddGoalSelceted = false }) {
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
    }
    
       func createGoal() {
        if self.isHavingSubgoals { self.importance = Importance.none.description }
        let goal = Goal(uid: self.userService.user.uid, title: self.title, note: self.note, importance: getImportance(importance: self.importance), satisfaction: 0, dueDate: self.deadline, categories: self.selectedCategories, isDecomposed: self.isHavingSubgoals)
            self.goalService.saveGoal(goal: goal) { (result) in
                switch result {
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                case .success(()):
                    self.alertMessage = "Goal was sucssefully added"
                    self.isAddGoalSelceted = false
                }
            }
        }
        
        func getImportance(importance: String)->Importance {
            switch importance {
            case "Very Important":
                return .veryImportant
            case "Important":
                return .important
            case "Not Important":
                return .notImportant
            default:
                return .none
            }
    }
}
 

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(isAddGoalSelceted: .constant(true))
    }
}


var categoriesData: [Category] = [
    .init(name: "Work"),
    .init(name: "Study"),
    .init(name: "Relationships"),
    .init(name: "Life")
]


struct SelectCategoryView: View {
    @Binding var isCategoryPressed: Bool
    @Binding var selectedCategories: [Category]
    @Binding var categories: [Category]
    
    var body: some View {
        Section(header: Text("Press to select categories")) {
            HStack {
                Image(systemName: "tag")
                Text("Cateogries ")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                self.isCategoryPressed = true
            }
            if !self.selectedCategories.isEmpty{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.selectedCategories) { cateogry in
                            Button(action: { self.categories.append(cateogry) ; self.selectedCategories = self.selectedCategories.filter{!self.categories.contains($0)}}) {
                                HStack {
                                    VStack {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 10, height: 50)
                                            .foregroundColor(.white)
                                    }
                                    .frame(alignment: .leading)
                                    .padding(3)
                                    .background(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                                    
                                    Text(cateogry.name ?? "None")
                                }
                                .lineLimit(1)
                                .frame(height: 20, alignment: .leading)
                                .padding(.trailing)
                                .padding(.vertical, 5)
                                .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: self.isCategoryPressed ? 30 : 0, alignment: .leading)
                }
            }
            
            
            if self.isCategoryPressed && !self.categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories) { cateogry in
                            Button(action: {  self.selectedCategories.append(cateogry) ; self.categories = self.categories.filter{!self.selectedCategories.contains($0)} }) {
                                HStack {
                                    Text(cateogry.name ?? "None")
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

