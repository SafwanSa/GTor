//
//  GoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalsList: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var goalService: GoalService
    @State var isAddGoalSelceted = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(self.goalService.goals) { goal in
                        NavigationLink(destination: GoalView(goal: goal)) {
                            GoalCardView(goal: goal)
                        }
                         .buttonStyle(PlainButtonStyle())
                    }
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
                        .environmentObject(self.userService)
                        .environmentObject(self.goalService)
                    }
            )
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsList().environmentObject(UserService()).environmentObject(GoalService())
    }
}
