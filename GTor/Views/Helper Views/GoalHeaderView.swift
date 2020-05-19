//
//  GoalHeaderView.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct GoalHeaderView: View {
    var goal: Goal
    @Binding var isEditingMode: Bool
    @Binding var updatedTitle: String
    @Binding var updatedNote: String
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20.0) {
                        if isEditingMode {
                            TextField("\(self.goal.title ?? "Title")", text: self.$updatedTitle)
                                .font(.system(size: 20, weight: .regular))
                            TextField("\(self.goal.note!.isEmpty ? "Note (Optional)" : self.goal.note ?? "Note")", text: self.$updatedNote)
                                .font(.subheadline)
                        }else{
                            Text(self.goal.title ?? "Title")
                                .font(.system(size: 20, weight: .regular))
                            Text(self.goal.note ?? "Goal Note")
                                .font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground).opacity(isEditingMode ? 1 : 0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                
            }
            .background(Image(uiImage: #imageLiteral(resourceName: "shape-pdf-asset")).resizable().scaledToFill())
            .frame(width: screen.width - 60, height: 170)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
        
    }
}

struct GoalHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GoalHeaderView(goal: .dummy, isEditingMode: .constant(false), updatedTitle: .constant(""), updatedNote: .constant(""))
    }
}
