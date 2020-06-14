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
    @Binding var selectedGoals: [Goal]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Main Goals")) {
                    ForEach(goalService.goals) { goal in
                        NavigationLink(destination: LinkedSubGoalsView(goal: goal, selectedGoals: self.$selectedGoals)) {
                            Text(goal.title ?? "")
                        }
                    }
                }
                
                Section(header: Text("Linked Goals")) {
                    ForEach(selectedGoals) { goal in
                        Text(goal.title ?? ";")
                    }
                }

            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Linked Goals")
            .navigationBarItems(leading:
                Button(action: { self.selectedGoals.removeAll() ; self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                ,trailing:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
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
