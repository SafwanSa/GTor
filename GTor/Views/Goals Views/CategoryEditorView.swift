//
//  CategoryEditorView.swift
//  GTor
//
//  Created by Safwan Saigh on 04/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct CategoryEditorView: View {
    @ObservedObject var categoryService = CategoryService.shared
    @ObservedObject var userService = UserService.shared

    @State var categories: [Category] = []
    @State var title = ""
    @State var color = GTColor.none
    @State var isEditMode = false
    @State var selectedCategory = Category.init(uid: "", name: "", colorId: -1)
    
    
    var body: some View {
        NavigationView {
            List {
                Picker(selection: $color, label: Text("Color")) {
                    ForEach(GTColor.allCases.filter { $0 != .none } , id: \.self) { color in
                        Color(color.color)
                            .opacity(0.7)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                
                HStack {
                    TextField("Title", text: $title)
                    
                    Button(action: {
                        if self.isEditMode {
                            self.categories.removeAll { $0.id == self.selectedCategory.id }
                        }
                        self.categories.append(.init(uid: self.userService.user.uid, name: self.title, colorId: self.color.rawValue))
                        self.isEditMode = false
                        self.title = ""
                        self.color = .none
                        
                    }) {
                        Text(isEditMode ? "Done" :"Add")
                    }
                }
                
                Section {
                    ForEach(categories) { category in
                        HStack {
                            Button(action: {self.categories.removeAll { $0.id == category.id } }) {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Color(GTColor.init(rawValue: category.colorId)!.color)
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text(category.name)
                            
                            Spacer()
                            
                            Button(action: {
                                self.isEditMode = true
                                self.selectedCategory = category
                                self.title = category.name
                                self.color = GTColor(rawValue: category.colorId)!
                            }) {
                            Text("Edit")
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Categories", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: save) {
                    Text("Save")
                }
            )
        }
    }
    
    func save() {
        for category in categories {
            categoryService.saveCategory(category: category) { _ in }
        }
        for category in categoryService.categories.filter({ !self.categories.contains($0) }) {
            self.categoryService.deleteCategory(category: category) { _ in }
        }
    }
}

struct CategoryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryEditorView()
        }
    }
}

