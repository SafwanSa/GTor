//
//  LinkedSubGoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct LinkedSubGoalsView: View {
    @ObservedObject var goalService = GoalService.shared
    @State var selectedGoal: Goal = .dummy
    var goal: Goal
    @Binding var selectedGoals: [Goal]

    var body: some View {
        List {
            Picker(selection: $selectedGoal, label: Text("Linked Goal")) {
                if goal.isDecomposed {
                    ForEach(goal.subGoals!, id: \.self) { subGoal in
                        Text(subGoal.title ?? "")
                    }
                }else {
                    ForEach(goalService.goals.filter { $0.id == goal.id }, id: \.self) { goal in
                        Text(goal.title ?? "")
                    }
                }

            }
            .onAppear {
                if self.selectedGoal.id != Goal.dummy.id && !self.selectedGoals.contains(self.goal) { self.selectedGoals.append(self.selectedGoal) }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)

    }
}

struct LinkedSubGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedSubGoalsView(goal: .dummy, selectedGoals: .constant([]))
    }
}
