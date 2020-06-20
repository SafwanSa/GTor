//
//  GoalCardView2.swift
//  GTor
//
//  Created by Safwan Saigh on 19/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalCardView2: View {
    var goal: Goal
    var mainGoal: Goal

    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text(goal.title)
                        .font(.headline)
                    Text(goal.note)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer()
                HStack {
                    Text("Progress: \(goal.satisfaction*100)%")
                    if goal.isDecomposed {
                        Spacer()
                        Text("SubGoals: \(GoalService.shared.getSubGoals(mainGoal: mainGoal).count)")
                    }else {
                        if goal.isSubGoal {
                            Spacer()
                            Text("Activities: \(TaskService.shared.tasks.filter {$0.linkedGoals!.contains(self.goal)}.filter {$0.isSatisfied}.count)/\(TaskService.shared.tasks.filter {$0.linkedGoals!.contains(self.goal)}.count)")
                        }
                    }
                    Spacer()
                    Text("\(Date(), formatter: dateFormatter2)")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.primary.opacity(0.3), radius: 20, x: 0, y: 20)
        .overlay(
            HStack {
                Color.red
                    .frame(width: 8)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                Spacer()
        })
        
    }
}

struct GoalCardView2_Previews: PreviewProvider {
    static var previews: some View {
        GoalCardView2(goal: .dummy, mainGoal: .dummy)
    }
}
