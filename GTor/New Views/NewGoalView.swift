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
                NewGoalHeaderView()
                
                DateCardView()
                
                NavigationLink(destination: SubGoalsList(goal: .constant(.dummy))) {
                    NewSubGoalsCardView()
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
    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            HStack {
                Text("Goal title")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Edit")
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
                .padding(.horizontal)
            
            HStack {
                Text("Goal note")
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Edit")
                }
            }
        }
        .foregroundColor(Color("Primary"))
        .padding()
        .background(Color("Level 0"))
        .elevation()
        .overlay(
            ProgressBarView(color1: Color("Level 3"), color2: Color.red, percentage: 50, fullWidth: 351, width: 343)
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
    }
}

struct DateCardView: View {
    var body: some View {
        VStack {
            NewCardView(content:
                AnyView (
                    HStack {
                        Text("12, April 2020")
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Edit")
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
