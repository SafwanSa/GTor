//
//  SelectCategoryView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct SelectCategoryView: View {
    @ObservedObject var categoryService = CategoryService.shared
    @Binding var isCategoryPressed: Bool
    @Binding var selectedCategories: [Category]
    @Binding var categories: [Category]
    @State var isEditCategoriesPresented = false

    var body: some View {
        Section(header:
            HStack {
                Text(NSLocalizedString("pressToSelectCategories", comment: ""))
                Spacer()
                Button(action: { self.isEditCategoriesPresented = true }) {
                    Text(NSLocalizedString("edit", comment: ""))
                }
            }
        ) {
            HStack {
                Image(systemName: "tag")
                Text("\(NSLocalizedString("categories", comment: "")) ")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                self.isCategoryPressed = true
            }
            if !self.selectedCategories.isEmpty{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.selectedCategories) { category in
                            Button(action: { self.categories.append(category) ; self.selectedCategories = self.selectedCategories.filter{!self.categories.contains($0)}}) {
                                HStack {
                                    VStack {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 10, height: 50)
                                            .foregroundColor(.black)
                                    }
                                    .frame(alignment: .leading)
                                    .padding(3)
                                    .background(Color(GTColor.init(rawValue: category.colorId ?? 0)!.color).opacity(0.5))

                                    Text(category.name)
                                }
                                .lineLimit(1)
                                .frame(height: 20, alignment: .leading)
                                .padding(.trailing)
                                .padding(.vertical, 5)
                                .background(Color(GTColor.init(rawValue: category.colorId ?? 0)!.color).opacity(0.5))
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
                        ForEach(categories) { category in
                            Button(action: {  self.selectedCategories.append(category) ; self.categories = self.categories.filter{!self.selectedCategories.contains($0)} }) {
                                HStack {
                                    Text(category.name)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color(GTColor.init(rawValue: category.colorId ?? 0)!.color).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditCategoriesPresented) {
            CategoryEditorView(categories: self.categoryService.categories)
        }
    }
}

