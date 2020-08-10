//
//  GoalHeaderView.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct GoalHeaderView: View {
    @Binding var goal: Goal
    @Binding var isEditingMode: Bool
    
    var body: some View {
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "shape1"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                    Spacer()
                    VStack {
                        VStack(alignment: .leading, spacing: 20.0) {
                            if isEditingMode {
                                TextField("\(self.goal.title)", text: self.$goal.title)
                                    .font(.system(size: 20, weight: .regular))
                                TextField("\(self.goal.note.isEmpty ? "noteOptional" : self.goal.note)", text: $goal.note)
                                    .font(.subheadline)
                            }else{
                                Text(self.goal.title)
                                    .font(.system(size: 20, weight: .regular))
                                Text(self.goal.note)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color("Level 0").opacity(isEditingMode ? 1 : 0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow()
            }
        }

    }
}

struct GoalHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GoalHeaderView(goal: .constant(.dummy), isEditingMode: .constant(false))
    }
}


struct TaskHeaderView: View {
    @Binding var task: Task
    @Binding var isEditingMode: Bool
    
    var body: some View {
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "shape-pdf-asset"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                    Spacer()
                    VStack {
                        VStack(alignment: .leading, spacing: 20.0) {
                            if isEditingMode {
                                TextField("\(self.task.title)", text: self.$task.title)
                                    .font(.system(size: 20, weight: .regular))
                                TextField("\(self.task.note.isEmpty ? "noteOptional" : self.task.note)", text: $task.note)
                                    .font(.subheadline)
                            }else{
                                Text(self.task.title)
                                    .font(.system(size: 20, weight: .regular))
                                Text(self.task.note)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color("Level 0").opacity(isEditingMode ? 1 : 0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow()
            }
        }

    }
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let n: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: n)
    }
}
