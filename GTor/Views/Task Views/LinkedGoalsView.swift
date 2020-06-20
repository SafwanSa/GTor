//
//  LinkedGoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 12/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct LinkedGoalsView: View {
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedGoalsIds: Set<UUID> = []
    @Binding var selectedGoals: [UUID]
    
    var body: some View {
        NavigationView {
            List(selection: $selectedGoalsIds) {
                Section(header: Text("Main Goals")) {
                    ForEach(goalService.getMainGoals().filter {!$0.isDecomposed}) {goal in
                        Text(goal.title)
                    }
                }
                
                Section(header: Text("Sub Goals")) {
                    ForEach(goalService.goals.filter {$0.isSubGoal}) {goal in
                        Text("\(self.goalService.getMainGoals().filter { $0.id == goal.mid }.first?.title ?? "") > \(goal.title)")
                    }
                }
            }
            .environment(\.editMode, .constant(EditMode.active))
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Linked Goals")
            .navigationBarItems(leading:
                Button(action: { self.selectedGoalsIds.removeAll() ; self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                ,trailing:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Done")
                }
            )
            .onDisappear {
                for id in self.selectedGoalsIds {
                    self.selectedGoals.append(id)
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
