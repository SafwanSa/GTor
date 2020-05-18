//
//  SelectCategoryView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


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

