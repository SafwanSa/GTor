//
//  GoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalsList: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var goalService = GoalService.shared
    @State var isAddGoalSelceted = false

    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(goalService.getMainGoals()) { goal in
                        NavigationLink(destination: SubGoalView(mainGoal: .constant(goal), goal: goal)) {
                            GoalCardView2(goal: goal, mainGoal: goal)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
        
                }
                .frame(width: screen.width)
                .padding(.horizontal, 16)
                .padding(.top, 120)
            }
            .background(Color("Level 1"))
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("My Goals", displayMode: .inline)
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
                .sheet(isPresented: self.$isAddGoalSelceted) {
                    AddGoalView()
                }
            )
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsList()
    }
}
