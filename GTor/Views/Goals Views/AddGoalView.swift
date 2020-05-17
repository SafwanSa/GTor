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
    @State var category = ""
    @State var title = ""
    @State var note = ""
    @State var deadline = Date()
    @State var selectedImportance = 0
    @State var importance: String?
    
    @State var isHavingDeadline = false
    @State var isHavingSubgoals = true
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
        NavigationView {
            List {
                SelectCategoryView(isCategoryPressed: self.$isCategoryPressed, selectedCategories: self.$selectedCategories, categories: self.$categories)
                
                Section {
                    TextField("Title", text: self.$category)
                    TextField("Note", text: self.$category)
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
                    Text("Add Sub Goals")
                    }
                }
                
                if !self.isHavingSubgoals {

                Section {
                    HStack {
                            Text("Importance")
                            TextFieldWithPickerAsInputView(data: importances, placeholder: "Importance", selectionIndex: self.$selectedImportance, text: self.$importance)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Add Goal")
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

var importances = ["Very Important", "Important", "Not Important"]

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


struct TextFieldWithPickerAsInputView : UIViewRepresentable {
    
    var data : [String]
    var placeholder : String
    
    @Binding var selectionIndex : Int
    @Binding var text : String?
    
    private let textField = UITextField()
    private let picker = UIPickerView()
    
    func makeCoordinator() -> TextFieldWithPickerAsInputView.Coordinator {
        Coordinator(textfield: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldWithPickerAsInputView>) -> UITextField {
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        textField.placeholder = placeholder
        textField.inputView = picker
        //            textField.backgroundColor = .secondarySystemFill
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 20)
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldWithPickerAsInputView>) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate {
        
        private let parent : TextFieldWithPickerAsInputView
        
        init(textfield : TextFieldWithPickerAsInputView) {
            self.parent = textfield
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.$selectionIndex.wrappedValue = row
            self.parent.text = self.parent.data[self.parent.selectionIndex]
            self.parent.textField.endEditing(true)
            
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.textField.resignFirstResponder()
        }
    }
}

