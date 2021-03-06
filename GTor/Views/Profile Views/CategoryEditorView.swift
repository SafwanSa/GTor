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
    @Environment(\.presentationMode) private var presentationMode

    @State var categories: [Category] = []
    @State var title = ""
    @State var color = GTColor.none
    @State var isEditMode = false
    @State var selectedCategory = Category.init(uid: "", name: "", colorId: -1)
    
    @State var alertMessage = "None"
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
            ZStack {
                List {
                    Picker(selection: $color, label: Text(NSLocalizedString("color", comment: ""))) {
                        ForEach(GTColor.allCases.filter { $0 != .none } , id: \.self) { color in
                            Color(color.color)
                                .opacity(0.7)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                    
                    HStack {
                        TextField(NSLocalizedString("title", comment: ""), text: $title)
                        
                        Button(action: {
                            self.isLoading = true
                            if self.title.isEmpty {
                                self.isLoading = false
                                self.alertMessage = CategoryErrors.noName.localizedDescription
                                self.isShowingAlert = true
                                return
                            }else if self.color == .none {
                                self.isLoading = false
                                self.alertMessage = CategoryErrors.noName.localizedDescription
                                self.isShowingAlert = true
                                return
                            }
                            if self.isEditMode {
                                self.categories.removeAll { $0.id == self.selectedCategory.id }
                            }
                            self.categories.append(.init(uid: self.userService.user.uid, name: self.title, colorId: self.color.rawValue))
                            self.isEditMode = false
                            self.title = ""
                            self.color = .none
                            self.isLoading = false
                        }) {
                            Text(isEditMode ? NSLocalizedString("done", comment: "") : NSLocalizedString("add", comment: ""))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        .foregroundColor(Color("Button"))
                    }
                    
                    Section {
                        ForEach(categories) { category in
                            HStack {
                                Button(action: {self.categories.removeAll { $0.id == category.id } }) {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(Color("Button"))
                                
                                Color(GTColor.init(rawValue: category.colorId ?? 0)!.color).opacity(0.7)
                                    .frame(width: 30, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Text(category.name)
                                
                                Spacer()
                                
                                Button(action: {
                                    self.isEditMode = true
                                    self.selectedCategory = category
                                    self.title = category.name
                                    self.color = GTColor(rawValue: category.colorId ?? 0)!
                                }) {
                                Text(NSLocalizedString("edit", comment: ""))
                                    .foregroundColor(Color("Button"))
                                }
                                .buttonStyle(PlainButtonStyle())

                            }
                            .contentShape(Rectangle())
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("\(NSLocalizedString("tagsSettings", comment: ""))", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: save) {
                        Text(NSLocalizedString("save", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                )
                
                LoadingView(isLoading: $isLoading)
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(self.alertMessage))
            }
            .onAppear {
                if self.categories.count == self.categoryService.categories.count || self.categories.isEmpty {
                    self.categories = self.categoryService.categories
                }
            }
    }
    
    func save() {
        for category in categories {
            categoryService.saveCategory(category: category) { _ in }
        }
        for category in categoryService.categories.filter({ !self.categories.contains($0) }) {
            self.categoryService.deleteCategory(category: category) { _ in }
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryEditorView()
        }
    }
}

