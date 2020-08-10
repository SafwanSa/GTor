//
//  LinkedGoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 12/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct LinkedGoal: Identifiable{
    var id: UUID
    var name: String
}

struct LinkedGoalsView: View {
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedGoalsIds: Set<UUID> = []
    @Binding var selectedGoals: [UUID]
    @State var allGoals: [LinkedGoal] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                List(selection: $selectedGoalsIds) {
                    Section {
                        ForEach(allGoals) {goal in
                            Text(goal.name)
                        }
                    }
                }
                .environment(\.editMode, .constant(EditMode.active))
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("\(NSLocalizedString("Linked Goals", comment: ""))")
                .navigationBarItems(leading:
                    Button(action: { self.selectedGoalsIds.removeAll() ; self.presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("Cancel", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                    ,trailing:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("Done", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                )
                    .onAppear {
                        for goal in self.goalService.goals {
                            if !goal.isSubGoal && goal.isDecomposed {
                                if !self.goalService.getSubGoals(mainGoal: goal).isEmpty {
                                    for subGoal in self.goalService.getSubGoals(mainGoal: goal) {
                                        self.allGoals.append(.init(id: subGoal.id, name: goal.title + " -> \(subGoal.title)"))
                                    }
                                }
                            }else if !goal.isSubGoal && !goal.isDecomposed {
                                self.allGoals.append(.init(id: goal.id, name: goal.title))
                            }
                        }
                }
                .onDisappear {
                    for id in self.selectedGoalsIds {
                        self.selectedGoals.append(id)
                    }
                }
                if allGoals.isEmpty {
                    NoDataView(title: NSLocalizedString("You do not have goals to link this task. ", comment: ""), actionTitle: "", action: {})
                }
            }
        }
    }
}

struct LinkedGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedGoalsView(selectedGoals: .constant([]))
    }
}
