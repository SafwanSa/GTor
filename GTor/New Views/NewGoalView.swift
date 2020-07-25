//
//  NewAddGoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 25/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct NewGoalView: View {
    @ObservedObject var goalService = GoalService.shared
    @Environment(\.presentationMode) private var presentationMode
    @Binding var mainGoal: Goal
    @State var goal: Goal = .dummy
    @State var goalCopy = Goal.dummy
    @State var isEditingMode = false
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40.0) {
                NewGoalHeaderView(goal: $goal)
                
                DateCardView(goal: $goal)
                
                if goal.isSubGoal {
                    NewTasksInfoView(goal: goal)
                }else {
                    NavigationLink(destination: SubGoalsList(goal: self.$goal)) {
                        NewSubGoalsCardView()
                    }
                }
            }
            .padding()
        }
    }
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(mainGoal: .constant(.dummy))
    }
}

struct NewGoalHeaderView: View {
    @Binding var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
                .padding(.horizontal)
            
            HStack {
                Text(goal.note.isEmpty ? "Empty Note" : goal.note)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
            }
        }
        .foregroundColor(Color("Primary"))
        .padding()
        .background(Color("Level 0"))
        .elevation()
        .overlay(
            ProgressBarView(color1: Color("Level 3"), color2: Color.red, percentage: self.goal.satisfaction, fullWidth: 351, width: 343)
        )
    }
}

struct NewCardView: View {
    var content: AnyView
    
    var body: some View {
        VStack {
            content
        }
        .padding(22)
        .background(Color("Level 0"))
        .elevation()
        .foregroundColor(Color("Primary"))
    }
}

struct DateCardView: View {
    @Binding var goal: Goal
    
    var body: some View {
        VStack {
            NewCardView(content:
                AnyView (
                    HStack {
                        Text(goal.dueDate != nil ? "\(goal.dueDate!, formatter: dateFormatter2)" : "No deadline")
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Edit")
                                .foregroundColor(Color("Button"))
                                .font(.callout)
                        }
                    }
            ))
        }
    }
}

struct NewSubGoalsCardView: View {
    var body: some View {
        VStack {
            NewCardView(content: AnyView(
                HStack {
                    Text("Sub Goals")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            ))
        }
    }
}

struct NewTasksInfoView: View {
    @ObservedObject var goalService = GoalService.shared
    var goal: Goal
    var body: some View {
        VStack {
            NewCardView(content: AnyView(
                HStack {
                    Text("Linked Tasks")
                    Spacer()
                    Text("\(self.goalService.getTasks(goal: self.goal).filter { $0.isSatisfied }.count)/\(self.goalService.getTasks(goal: self.goal).count)")
                }
            ))
        }
    }
}
