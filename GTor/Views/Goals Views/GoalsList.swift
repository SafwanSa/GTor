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
    @State var mainGoals: [Goal] = []
    var mainGoalsCopy: [Goal] {
        goalService.getMainGoals()
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(mainGoals.indices) { index in
                        NavigationLink(destination: GoalView(goal: self.$mainGoals[index])) {
                            GoalCardView2(goal: self.mainGoals[index], mainGoal: self.mainGoals[index])
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .onAppear {
                    self.mainGoals = self.mainGoalsCopy
                }
                .frame(width: screen.width)
                .padding(.horizontal, 16)
                .padding(.top, 150)
            }
            .navigationBarTitle("My Goals")
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
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsList()
    }
}
