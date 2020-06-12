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
    @Binding var selectedGoals: [Goal]
    
    var body: some View {
        NavigationView {
            List(selection: $selectedGoalsIds) {
                ForEach(goalService.goals) { goal in
                    Text(goal.title ?? "Goal Title")
                }

            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.editMode, .constant(EditMode.active))
            .navigationBarTitle("Linked Goals")
            .navigationBarItems(leading:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                ,trailing:
                Button(action: { self.selectedGoals = self.goalService.goals.filter { self.selectedGoalsIds.contains($0.id) } ; self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Done")
                }
            )
        }
    }
}

struct LinkedGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedGoalsView(selectedGoals: .constant([]))
    }
}
