//
//  ImportanceCard.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct ImportanceCard: View {
    var goal: Goal
    let importances = ["Very Important", "Important", "Not Important"]
    @State var selectedImportanceIndex = -1

    @Binding var isEditingMode: Bool
    @Binding var updatedImportance: String
    
    var body: some View {
        HStack {
            Text("Importance")
            if isEditingMode && !self.goal.isDecomposed {
                Spacer()
                TextFieldWithPickerAsInputView(data: self.importances, placeholder: "Importance", selectionIndex: self.$selectedImportanceIndex, text: self.$updatedImportance)
                    .padding()
                    .foregroundColor(.primary)
            }else {
                Spacer()
                Text("\(self.goal.importance.description)")
                    .padding()
                    .foregroundColor(.primary)
            }
            if goal.subGoals?.count == 0 {
                Image(systemName: "exclamationmark.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16, alignment: .leading)
                Text("Add Sub Goals")
            }
        }
        .modifier(SmallCell())
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(self.goal.importance.value)
        })
    }
}


struct ImportanceCard_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceCard(goal: .dummy, isEditingMode: .constant(false), updatedImportance: .constant(""))
    }
}
