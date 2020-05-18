//
//  GoalView.swift
//  GTor
//
//  Created by Safwan Saigh on 15/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalView: View {
    @EnvironmentObject var goalService: GoalService
    var goal: Goal
    @State var isSubGoalsListExpanded = false
    @State var isEditingMode = false
    @State var isShowingAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40.0) {
                HeaderView(goal: goal, isEditingMode: self.$isEditingMode)
                    .blur(radius: self.isSubGoalsListExpanded ? 3 : 0)
                    .scaleEffect(isSubGoalsListExpanded ? 0.9 : 1)
                    .animation(.spring())
                
                ImportanceCard(goal: goal, isEditingMode: self.$isEditingMode)
                    .blur(radius: self.isSubGoalsListExpanded ? 3 : 0)
                    .scaleEffect(isSubGoalsListExpanded ? 0.9 : 1)
                    .animation(.spring())
                
                
                if goal.isDecomposed {
                    SubGoalsList(isSubGoalsListExpanded: self.$isSubGoalsListExpanded, isEditingMode: self.$isEditingMode, goal: goal)
                }
                
                
                Section {
                    HStack {
                        Button(action: { self.isShowingAlert = true } ) {
                            Text("Delete the goal")
                                .foregroundColor(.red)
                        }
                    }
                    .font(.headline)
                           .frame(width: screen.width - 60, height: 20)
                           .padding(10)
                           .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(1), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
                           .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                           .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                }
                .alert(isPresented: self.$isShowingAlert) {
                    Alert(title: Text("Are you sure you want to delete this goal?"), message: Text("All the Sub Goals of this goal will be deleted also"), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
                        self.deleteGoal()
                    }))
                }
                
                
            }
            .padding(.top, 50)
        }
        .navigationBarTitle("\(self.goal.title ?? "Title")")
        .navigationBarItems(trailing:
            Group {
                if self.isEditingMode {
                    HStack(spacing: 50) {
                        Button(action: { /*cancel*/ self.isEditingMode = false  }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                .font(.headline)
                        }
                        Button(action: { /*save*/ }) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                .font(.headline)
                        }
                    }
                }else {
                    HStack {
                        Spacer()
                        Button(action: { self.isEditingMode = true }) {
                            Image(systemName: "pencil")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                .font(.headline)
                        }
                    }
                }
            }
        )
    }
    
    func deleteGoal(){
        self.goalService.deleteGoal(goal: self.goal) { (result) in
            switch result {//TODO show message after deleting
            case .failure(let error):
                self.isEditingMode = true
            case .success(()):
                self.isEditingMode = false
            }
        }
    }
    
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(goal: .dummy)
    }
}

struct HeaderView: View {
    var goal: Goal
    @Binding var isEditingMode: Bool
    @State var updatedTitle: String = ""
    @State var updatedNote: String = ""
    @State var updatedDeadline: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20.0) {
                        if isEditingMode {
                            TextField("\(self.goal.title ?? "Title")", text: self.$updatedTitle)
                                .font(.title)
                            TextField("\(self.goal.note ?? "Note")", text: self.$updatedNote)
                                .font(.subheadline)
                        }else{
                            Text(self.goal.title ?? "Title")
                                .font(.title)
                            Text(self.goal.note ?? "Goal Note")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    if isEditingMode {
                        TextField("\(self.goal.dueDate?.description ?? "100")", text: self.$updatedDeadline)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 5)
                    }else{
                        Text(self.goal.dueDate?.description ?? "100")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 5)
                    }
                }
                .padding()
                .background(Color.white.opacity(isEditingMode ? 1 : 0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                
            }
            .background(Image(uiImage: #imageLiteral(resourceName: "shape-pdf-asset")).resizable().scaledToFill())
            .frame(width: screen.width - 60, height: 170)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

