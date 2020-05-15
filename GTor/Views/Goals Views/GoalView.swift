//
//  GoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 15/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalView: View {
    var goal: Goal
    @State var isSubGoalsExpanded = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40.0) {
                CardView()
                
                ImportanceCard()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sub Goals")
                            .font(.title)
                            .padding(.leading, 20)
                        Spacer()
                        if isSubGoalsExpanded {
                            
                        }
                        Button(action: {  }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        .opacity(isSubGoalsExpanded ? 1 : 0)
                        .offset(x: self.isSubGoalsExpanded ? 0 : 20)
                        .animation(.spring())
                        
                        Image(systemName: self.isSubGoalsExpanded ? "chevron.down" : "chevron.up")
                            .padding()
                    }
                    if isSubGoalsExpanded {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(self.goal.subGoals ?? []) { goal in
                                    GoalCardView(goal: goal)
                                }
                            }
                            .padding(.bottom, 30)
                        }
                    }
                }
                .frame(maxWidth:.infinity)
                .padding(.vertical)
                .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                .animation(.easeInOut)
                .onTapGesture {
                    self.isSubGoalsExpanded.toggle()
                }
                
            }
            .padding(.top, 50)
        }
        .navigationBarTitle("\(self.goal.title ?? "Title")")
        
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(goal: .dummy)
    }
}

struct CardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20.0) {
                        Text("Goal title")
                            .font(.title)
                        Text("Goal Note")
                            .font(.subheadline)
                    }
                    Spacer()
                    Text("2020-10-10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 5)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                
            }
            .background(Image(uiImage: #imageLiteral(resourceName: "shape-pdf-asset")).resizable().scaledToFill())
            .frame(width: screen.width - 60, height: 170)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct ImportanceCard: View {
    var body: some View {
        HStack {
            Text("Importance")
            Spacer()
            Text("\("Very Important")")
                .padding()
                .foregroundColor(.primary)
        }
        .font(.headline)
        .frame(width: screen.width - 60, height: 20)
        .padding(10)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(1), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
        })
    }
}
