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
                                TextField("\(self.goal.note.isEmpty ? "Note (Optional)" : self.goal.note)", text: $goal.note)
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
                    .background(Color(UIColor.secondarySystemGroupedBackground).opacity(isEditingMode ? 1 : 0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
        }

    }
}

struct GoalHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GoalHeaderView(goal: .constant(.dummy), isEditingMode: .constant(false))
    }
}
