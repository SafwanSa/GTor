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
    @State var selectedImportance = Importance.none
    @Binding var isEditingMode: Bool
    
    var body: some View {
        HStack {
            Text("Importance")
            if isEditingMode && !self.goal.isDecomposed {
                Spacer()
                Picker(selection: $selectedImportance, label: Text("Importance")) {
                    ForEach(Importance.allCases.filter { $0 != .none }, id: \.self) { importance in
                        Text(importance.rawValue)
                    }
                }
            }else {
                Spacer()
                Text(self.goal.importance.rawValue)
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
        ImportanceCard(goal: .dummy, isEditingMode: .constant(false))
    }
}
