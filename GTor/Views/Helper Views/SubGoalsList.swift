//
//  SubGoalsList.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct SubGoalsList: View {
    @Binding var isSubGoalsListExpanded: Bool
    @Binding var isEditingMode: Bool
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Sub Goals")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.leading, 20)
                Spacer()
                Button(action: {  }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 23, height: 23)
                        .foregroundColor(.black)
                }
                .opacity(isSubGoalsListExpanded ? 1 : 0)
                .offset(x: self.isSubGoalsListExpanded ? 0 : 20)
                .animation(.spring())
                
                Image(systemName: self.isSubGoalsListExpanded ? "chevron.down" : "chevron.up")
                    .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.isSubGoalsListExpanded.toggle()
            }
            if isSubGoalsListExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.goal.subGoals ?? []) { goal in
                            NavigationLink(destination: GoalView(goal: goal)) {
                                GoalCardView(goal: goal)
                                    .padding(.leading)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .frame(maxWidth:.infinity)
        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .animation(.easeInOut)
    }
}
