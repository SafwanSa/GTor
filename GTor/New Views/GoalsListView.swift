//
//  GoalsListView.swift
//  GTor
//
//  Created by Safwan Saigh on 25/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalsListView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10.0) {
                    ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                        NewGoalCadView().padding()
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationBarTitle("My Goals", displayMode: .inline)
        }
    }
}

struct GoalsListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsListView()
    }
}

struct NewGoalCadView: View {
    var goal: Goal = .dummy
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15.0) {
                HStack {
                    Text("Work")
                        .font(.system(size: 10))
                        .padding(6)
                        .background(Color("Level 3"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Text(goal.title)
                    .font(.system(size: 14))
                
                HStack {
                    Text("Tasks: 1/10")
                    Spacer()
                    Text("12, April 2020")
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
            ProgressBarView(color1: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), color2: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), percentage: 50)
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
