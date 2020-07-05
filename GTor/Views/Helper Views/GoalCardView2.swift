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
                .background(Color("Level 0").opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                
                Spacer()
                
                HStack {
                    Text("Progress: \(String(format: "%.2f", arguments: [goal.satisfaction]))%")
                    if goal.isDecomposed {
                        Spacer()
                        Text("SubGoals: \(GoalService.shared.getSubGoals(mainGoal: mainGoal).count)")
                    }else {
                        if goal.isSubGoal {
                            Spacer()
                            Text("Activities: \(GoalService.shared.getTasks(goal: self.goal).filter {$0.isSatisfied}.count)/\(GoalService.shared.getTasks(goal: self.goal).count)")
                        }
                    }
                    Spacer()
                    Text("\(Date(), formatter: dateFormatter2)")
                        .foregroundColor(Color("Level 3"))
                }
                .font(.caption)
                .padding(.horizontal)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 105)
        .padding(.bottom, 10)
        .background(Color("Level 1"))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow()
        .overlay(
            Group {
                if !self.goal.isSubGoal {
                    HStack {
                        Color(GTColor.init(rawValue: self.goal.categories[0].colorId ?? 0)!.color).opacity(0.5)
                            .frame(width: 8)
                            .frame(maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        Spacer()
                    }
                }
            }
        )
    }
}

struct GoalCardView2_Previews: PreviewProvider {
    static var previews: some View {
        GoalCardView2(goal: .dummy, mainGoal: .dummy)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color("Level 0"))
    }
}
