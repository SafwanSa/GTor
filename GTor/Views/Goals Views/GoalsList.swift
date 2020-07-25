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
                            NewGoalCardView(mainGoal: .dummy, goal: goal)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationBarTitle("My Goals", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { self.isAddGoalSelceted = true }) {
                    Image(systemName: "plus")
                        .resizable()
                        .imageScale(.large)
                        .foregroundColor(Color("Button"))
                        .font(.headline)
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


struct NewGoalCardView: View {
    @ObservedObject var goalService = GoalService.shared
    var mainGoal: Goal
    var goal: Goal
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15.0) {
                HStack {
                    ForEach(goal.categories) { category in
                        CategoryCardView(category: category)
                    }
                }
                
                Text(goal.title)
                    .font(.system(size: 14))
                
                HStack {
                    Text(goal.isSubGoal ? "Tasks: \(self.goalService.getTasks(goal: self.goal).filter {$0.isSatisfied}.count)/\(self.goalService.getTasks(goal: self.goal).count)" : "Sub-Goal: \(self.goalService.getSubGoals(mainGoal: goal).count)")
                    Spacer()
                    if goal.dueDate != nil { Text("\(goal.dueDate!, formatter: dateFormatter2)") }
                }
                .font(.system(size: 10))
                .foregroundColor(Color.secondary)
            }
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding(12)
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
        .overlay(
            ProgressBarView(color1: Color("Level 3"), color2: Color.red, percentage: self.goal.satisfaction)
        )
    }
}

struct ProgressBarView: View {
    var color1: Color
    var color2: Color
    var percentage: Double
    
    var body: some View {
        ZStack {
            HStack {
                color1
                Spacer()
            }
            HStack {
                color2
                    .frame(width: CGFloat((percentage / 100) * 343))
                Spacer()
            }
        }
        .frame(width: 351, height: 8)
        .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
        .offset(x: 4, y: 50)
    }
}

struct CategoryCardView: View {
    var category: Category
    
    var body: some View {
        Text(category.name)
            .font(.system(size: 10))
            .padding(6)
            .background(Color(GTColor.init(rawValue: self.category.colorId ?? 0)!.color).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
