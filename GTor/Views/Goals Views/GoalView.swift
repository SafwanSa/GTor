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
    @State var mainGoal = Goal.dummy
    @State var isSubGoalsListPresented = false
    @State var isEditingMode = false
    @State var isShowingAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40.0) {
                HeaderView(goal: goal, isEditingMode: self.$isEditingMode)

                if self.goal.dueDate != nil{
                    HStack {
                        Text("Deadline")
                        Spacer()
                        Text(self.goal.dueDate?.description ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 5)
                    }
                    .modifier(SmallCell())
                }
                
                ImportanceCard(goal: goal, isEditingMode: self.$isEditingMode)

                if goal.isDecomposed {
                    Button(action: { self.isSubGoalsListPresented = true }) {
                        HStack {
                            Text("Sub Goals")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .modifier(SmallCell())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: self.$isSubGoalsListPresented) {
                        SubGoalsList(goal: self.goal).environmentObject(self.goalService)
                    }
                }
                
                HStack {
                    Button(action: { if !self.isSubGoalsListPresented { self.isShowingAlert = true } } ) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete the goal")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        
                    }
                }
                .modifier(SmallCell())
                .alert(isPresented: self.$isShowingAlert) {
                    Alert(title: Text("Are you sure you want to delete this goal?"), message: Text("All the Sub Goals of this goal will be deleted also"), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
                        self.goal.isSubGoal ? self.deleteSubGoal() : self.deleteGoal()
                    }))
                }
                
                
            }
            .padding(.top, 50)
        }
        .navigationBarTitle("\(self.goal.title ?? "Title")")
        .navigationBarItems(trailing:
            Group {
                HStack(spacing: 50) {
                    if self.isEditingMode {
                        Button(action: { /*cancel*/ self.isEditingMode = false  }) {
                            Text("Cancel")
                        }
                        Button(action: { /*save*/ }) {
                            Text("Save")
                        }
                    }else if !self.isEditingMode && !self.isSubGoalsListPresented{
                            Button(action: {self.isEditingMode = true }) {
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
        
    func deleteSubGoal(){
        self.mainGoal.subGoals?.removeAll(where: { (goal) -> Bool in
            return goal.id == self.goal.id
        })
        self.goalService.updateSubGoals(mainGoal: self.mainGoal) { (result) in
            switch result {
            case .failure(let error):
                self.isEditingMode = true
            case .success(()):
                self.isEditingMode = false
            }
        }
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
        VStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20.0) {
                        if isEditingMode {
                            TextField("\(self.goal.title ?? "Title")", text: self.$updatedTitle)
                                .font(.system(size: 20, weight: .regular))
                            TextField("\(self.goal.note!.isEmpty ? "Note (Optional)" : self.goal.note ?? "Note")", text: self.$updatedNote)
                                .font(.subheadline)
                        }else{
                            Text(self.goal.title ?? "Title")
                                .font(.system(size: 20, weight: .regular))
                            Text(self.goal.note ?? "Goal Note")
                                .font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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

struct ImportanceCard: View {
    var goal: Goal
    @Binding var isEditingMode: Bool
    @State var updatedImportance = ""
    var body: some View {
        HStack {
            if isEditingMode && !self.goal.isDecomposed {
                Text("Importance")
                Spacer()
                TextField("\("Very Important")", text: self.$updatedImportance)
                    .padding()
                    .foregroundColor(.primary)
            }else {
                Text("Importance")
                Spacer()
                Text("\(self.goal.importance?.description ?? "")")
                    .padding()
                    .foregroundColor(.primary)
            }
            
        }
        .modifier(SmallCell())
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
