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
                    if goalService.getMainGoals().isEmpty {
                        NoDataView(title: NSLocalizedString("You do not have goals yet.", comment: ""), actionTitle: NSLocalizedString("Let's Start", comment: ""), action: { self.isAddGoalSelceted = true })
                    }else {
                        ForEach(goalService.getMainGoals()) { goal in
                            NavigationLink(destination: NewGoalView(mainGoal: .constant(goal), goal: goal)) {
                                NewGoalCardView(mainGoal: .dummy, goal: goal)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationBarTitle("\(NSLocalizedString("Goals", comment: ""))", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { self.isAddGoalSelceted = true }) {
                    Image(systemName: "plus")
                        .resizable()
                        .imageScale(.large)
                        .foregroundColor(Color("Button"))
                        .font(.headline)
                }
                .sheet(isPresented: self.$isAddGoalSelceted) {
                    NewAddGoalView(goal: .init(uid: self.userService.user.uid,
                                               title: "",
                                               note: "",
                                               isSubGoal: false,
                                               importance: .none,
                                               satisfaction: 0,
                                               categories: [],
                                               isDecomposed: true),
                                   mainGoal: .constant(.dummy))
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
    var mainGoal: Goal = .dummy
    var goal: Goal = .dummy
    
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
                
                if goal.isSubGoal { Spacer() }
                
                HStack {
                    Text(goal.isSubGoal ? "\(NSLocalizedString("Tasks", comment: "")): \(self.goalService.getTasks(goal: self.goal).filter {$0.isSatisfied}.count)/\(self.goalService.getTasks(goal: self.goal).count)"
                        : goal.isDecomposed ? "\(NSLocalizedString("Sub-Goal", comment: "")): \(self.goalService.getSubGoals(mainGoal: goal).count)" : "\(NSLocalizedString("Tasks", comment: "")): \(self.goalService.getTasks(goal: self.goal).filter {$0.isSatisfied}.count)/\(self.goalService.getTasks(goal: self.goal).count)")
                    Spacer()
                    if goal.dueDate != nil { Text("\(goal.dueDate!, formatter: dateFormatter2)") }
                }
                .font(.system(size: 10))
                .foregroundColor(Color.secondary)
            }
            
            HStack {
                Spacer()
                Image(systemName: NSLocalizedString("chevron.right", comment: ""))
            }
        }
        .frame(height: 83)
        .padding(12)
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
        .overlay(
            ProgressBar(value: self.goal.satisfaction/100)
        )
    }
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color("Primary"))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color("Primary"))
                    .animation(.linear)
            }
        }
        .frame(height: 5)
        .offset(y: 51)
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

struct NoDataView: View {
    var title: String
    var actionTitle: String
    var action: () -> ()
    
    var body: some View {
        VStack(spacing: 15.0) {
            Image("mentor-shape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .offset(x: 10, y: 55)
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color.secondary)
            Button(action: action) {
                Text(actionTitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color("Primary"))
                    .padding(.vertical, 13)
                    .padding(.horizontal, 20)
            }
            .background(Color("Button"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(actionTitle.isEmpty ? 0 : 1)
        }
        .opacity(0.8)
    }
}
