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
                    
                    Button(action: { self.goalService.goals.append(.dummy) }) {
                        Image(systemName: "plus")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                            .font(.headline)
                    }
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

struct GoalCardView: View {
    var goal: Goal
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                HStack {
                    Image(uiImage: #imageLiteral(resourceName: "shape1"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 90)
                }
                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .multilineTextAlignment(.leading)
                .offset(x: -10, y: -15)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(goal.title ?? "Title")
                        .font(.headline)
                    Text(goal.note ?? "Note")
                        .font(.subheadline)
                    
                    Color.secondary
                        .frame(height: 1)
                        .padding(.top, 20)
                    
                    
                    HStack(spacing: 20) {
                        Text(self.goal.isDecomposed ? "Sub-Goals: \(self.goal.subGoals?.count ?? 100)" : "")
                        Text("Activities: \(0)/3")//TODO
                        Text("\(self.goal.dueDate?.description ?? "100")")//TODO
                            .lineLimit(4)
                    }
                    .foregroundColor(Color.secondary)
                    .font(.footnote)
                    .offset(x: -60, y: 15)
                }
                .offset(y: -5)
                Spacer()
            }
        }
        .frame(width: screen.width - 40, height: 120)
        .padding(.leading, 16)
        .padding(.vertical, 16)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 10)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(self.goal.importance?.opacity ?? 0)
        })
    }
}
