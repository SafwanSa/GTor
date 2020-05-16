//
//  AddGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 16/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AddGoalView: View {
    @State var category = ""
    @State var title = ""
    @State var note = ""
    @State var deadline = ""
    
    @State var isHavingSubgoals = 0
    @State var isCategoryPressed = false
    @State var selectedCategories: [Category] = []
    @State var categories = categoriesData
//    init() {
//        UISegmentedControl.appearance().backgroundColor = .white
//        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
//    }
    
    var body: some View {
        List {
            SelectCategoryView(isCategoryPressed: self.$isCategoryPressed, selectedCategories: self.$selectedCategories, categories: self.$categories)
            
            Section {
                TextField("Title", text: self.$category)
                TextField("Note", text: self.$category)
            }
            
            Section {
                TextField("Deadline (Optinal)", text: self.$category)
            }
            
            Section(header: Text("Do you want to add sub goals?")) {
                Picker(selection: self.$isHavingSubgoals, label: Text("")) {
                    Text("Yes").tag(0)
                    Text("No").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
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

struct SelectCategoryView: View {
    @Binding var isCategoryPressed: Bool
    @Binding var selectedCategories: [Category]
    @Binding var categories: [Category]
    
    var body: some View {
        Section(header: Text("Select a category")) {
            HStack {
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

