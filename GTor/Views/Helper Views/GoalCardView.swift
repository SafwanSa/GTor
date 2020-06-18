//
//  GoalCardView.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct GoalCardView: View {
    var goal: Goal
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                HStack {
                    Image(uiImage: #imageLiteral(resourceName: "shape1"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 90)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .multilineTextAlignment(.leading)
                .offset(x: -10, y: -15)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(goal.title ?? "Title")
                        .font(.headline)
                    Text(goal.note ?? "Note")
                        .font(.subheadline)
                    
                    Color.secondary
                        .frame(height: 1)
                        .padding(.top, 20)
                    
                    
                    HStack(spacing: 20) {
                        if self.goal.isDecomposed { Text("Sub-Goals: \(self.goal.subGoals?.count ?? 0)") }
                        Text("Activities: \(0)/\(self.goal.tasks!.count)")//TODO
                        if self.goal.dueDate != nil { Spacer () ; Text("\(self.goal.dueDate!, formatter: dateFormatter2)") }
                    }
                    .foregroundColor(Color.secondary)
                    .font(.footnote)
                    .offset(x: -60, y: 15)
                }
                .offset(y: -5)
                Spacer()
            }
        }
        .frame(width: screen.width - 40, height: 120)
        .padding(.leading, 16)
        .padding(.vertical, 16)
        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGray).opacity(0.3), Color(UIColor.secondarySystemBackground)]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 10)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(self.goal.importance?.value ?? 0)
        })
    }
}

struct GoalCardView_Preview: PreviewProvider {
    static var previews: some View {
        GoalCardView(goal: .dummy)
    }
}
