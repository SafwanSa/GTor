//
//  SubGoalsList.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct SubGoalsList: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @State var isAddGoalSelceted = false
    @Environment(\.presentationMode) private var presentationMode
    @Binding var goal: Goal
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                if goalService.getSubGoals(mainGoal: goal).isEmpty {
                    NoDataView(title: NSLocalizedString("noSubGoals", comment: ""), actionTitle: NSLocalizedString("addSubGoal", comment: ""), action: { self.isAddGoalSelceted = true })
                }else {
                    ForEach(goalService.getSubGoals(mainGoal: goal)) { goal in
                        NavigationLink(destination: NewGoalView(mainGoal: self.$goal, goal: goal)) {
                            NewGoalCardView(mainGoal: self.goal, goal: goal)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .navigationBarTitle("\(NSLocalizedString("subGoals", comment: ""))", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: { self.isAddGoalSelceted = true }) {
                Image(systemName: "plus")
                    .resizable()
                    .imageScale(.large)
                    .foregroundColor(Color("Button"))
                    .font(.headline)
            }
            .sheet(isPresented: $isAddGoalSelceted) {
                NewAddGoalView(goal: .init(uid: self.userService.user.uid,
                                           title: "",
                                           note: "",
                                           isSubGoal: true,
                                           importance: .none,
                                           satisfaction: 0,
                                           categories: [],
                                           isDecomposed: false),
                               mainGoal: self.$goal)
            }
        )
    }
}


struct SubGoalsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubGoalsList(goal: .constant(.dummy))
        }
    }
}
