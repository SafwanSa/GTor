//
//  ImportanceCard.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct ImportanceCard: View {
    @Binding var goal: Goal
    @Binding var isEditingMode: Bool
    @State var isImportancePickerPresented = false
    
    var body: some View {
        HStack {
            Text("Importance")
            Spacer()
            if !goal.isDecomposed {
                Text(goal.importance.rawValue)
                if self.isEditingMode { Image(systemName: "chevron.right") }
            }else {
                if goal.subGoals!.count == 0 {
                    Image(systemName: "exclamationmark.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16, alignment: .leading)
                    Text("Add Sub Goals")
                }else {
                    Text(goal.importance.rawValue)
                    Image(systemName: "chevron.right")
                }
            }

            

        }
        .modifier(SmallCell())
        .overlay(
            HStack {
                Color.red
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(self.goal.importance.value)
                Spacer()
        })
            .onTapGesture {
                if self.isEditingMode && !self.goal.isDecomposed { self.isImportancePickerPresented = true }
        }
        .sheet(isPresented: $isImportancePickerPresented) {
            ImportancePickerView(goal: self.$goal)
        }
    }
}


struct ImportanceCard_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceCard(goal: .constant(.dummy), isEditingMode: .constant(false))
    }
}

struct ImportancePickerView: View {
    @Binding var goal: Goal
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: self.$goal.importance, label: Text("Importance")) {
                        ForEach(Importance.allCases.filter { $0 != .none }, id: \.self) { importance in
                            Text(importance.rawValue)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarItems(trailing:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
            })
        }
    }
}
