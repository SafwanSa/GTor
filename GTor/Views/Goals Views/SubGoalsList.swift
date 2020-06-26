//
//  SubGoalsList.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct SubGoalsList: View {
    @ObservedObject var goalService = GoalService.shared
    @State var isAddGoalSelceted = false
    @Environment(\.presentationMode) private var presentationMode
    @Binding var goal: Goal
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(goalService.getSubGoals(mainGoal: goal)) { goal in
                    NavigationLink(destination: SubGoalView(mainGoal: self.$goal, goal: goal)) {
                        GoalCardView2(goal: goal, mainGoal: self.goal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: screen.width)
            .padding(.horizontal, 16)
            .padding(.top, 150)
        }
        .navigationBarTitle("Sub Goals")
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                Button(action: {  }) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .imageScale(.large)
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                        .font(.headline)
                }
                Button(action: { self.isAddGoalSelceted = true }) {
                    Image(systemName: "plus")
                        .resizable()
                        .imageScale(.large)
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                        .font(.headline)
                }
            }
            .sheet(isPresented: $isAddGoalSelceted) {
                AddSubGoalView(goal: self.$goal)
            }
        )
            .edgesIgnoringSafeArea(.all)
        
        
    }
}


struct SubGoalsList_Previews: PreviewProvider {
    static var previews: some View {
        SubGoalsList(goal: .constant(.dummy))
    }
}
