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
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isShowingAlert = false
    @State var isLoading: Bool = false
    
    var isShowingSave: Bool {
        (goalCopy.title != goal.title || goalCopy.note != goal.note || goalCopy.dueDate != goal.dueDate)
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40.0) {
                    NewGoalHeaderView(goal: $goalCopy)
                    
                    if !goal.isSubGoal { GoalCategoriesCardView(goal: goalCopy) }
                    
                    DateCardView(date: $goal.dueDate)
                    
                    if goal.isSubGoal {
                        NewTasksInfoView(goal: goalCopy)
                    }else {
                        if goal.isDecomposed {
                            NavigationLink(destination: SubGoalsList(goal: self.$goalCopy)) {
                                NewSubGoalsCardView()
                            }
                        }else {
                            NewTasksInfoView(goal: goalCopy)
                        }
                    }
                    
                    DeleteGoalCardView(goal: $goalCopy, mainGoal: $mainGoal, isLoading: $isLoading)
                }
                .padding()
            }
            .navigationBarTitle("Goal", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: saveGoal) {
                    Text("Save")
                    .font(.callout)
                    .foregroundColor(Color("Button"))
                }
                .opacity(isShowingSave ? 1 : 0)
            )
            
            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            self.goalCopy = self.goal
        }
    }
    
    func saveGoal() {
        isLoading = true
        self.goal = self.goalCopy
        goalService.saveGoal(goal: self.goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                self.isLoading = false
            }
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
    @State var isShowingTitleEditor = false
    @State var isShowingNoteEditor = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: { self.isShowingTitleEditor = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTitleEditor) {
                    TextEditorView(title: "Edit Title", text: self.$goal.title)
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
                .padding(.horizontal)
            
            HStack {
                Text(goal.note.isEmpty ? "Empty Note" : goal.note)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: { self.isShowingNoteEditor = true }) {
                    Text("Edit")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingNoteEditor) {
                    TextEditorView(title: "Edit Note", text: self.$goal.note)
                }
            }
        }
        .foregroundColor(Color("Primary"))
        .padding()
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
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
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .elevation()
        .foregroundColor(Color("Primary"))
    }
}

struct GTorButton: View {
    var content: AnyView
    var backgroundColor: Color
    var foregroundColor: Color
    var action: () -> ()
    
    var body: some View {
        VStack {
            Button(action: action) {
                content
            }
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .elevation()
        .foregroundColor(foregroundColor)
    }
}

struct DateCardView: View {
    @Binding var date: Date?
    
    var body: some View {
        VStack {
            NewCardView(content:
                AnyView (
                    HStack {
                        Text(date != nil ? "\(date!, formatter: dateFormatter2)" : "No deadline")
                        
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

struct GoalCategoriesCardView: View {
    var goal: Goal
    
    var body: some View {
        VStack {
            NewCardView(content: AnyView(
                HStack {
                    Text("Categories")
                    Spacer()
                    ForEach(goal.categories) { category in
                        CategoryCardView(category: category)
                    }
                }
            ))
        }
    }
}

struct DeleteGoalCardView: View {
    @ObservedObject var goalService = GoalService.shared
    @ObservedObject var taskService = TaskService.shared
    @Environment(\.presentationMode) private var presentationMode
    @Binding var goal: Goal
    @Binding var mainGoal: Goal
    @State var isShowingDeleteAlert = false
    @State var alertMessage = ""
    @State var isShowingAlert = false
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            GTorButton(content: AnyView(
                HStack(spacing: 8.0) {
                    Image(systemName: "trash")
                    Text("Delete Goal")
                    Spacer()
                }
            ), backgroundColor: Color(.white), foregroundColor: Color("Primary"), action: { self.isShowingDeleteAlert = true })
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text("Are you sure you want to delete this goal?"),
                  message: Text(self.goal.isDecomposed ? "All the Sub Goals of this goal will be deleted also" : ""),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(Text("Delete"), action: deleteGoal))
        }
    }
    
    func deleteGoal(){
        isLoading = true
        goalService.deleteGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.isShowingAlert = true
                self.alertMessage = error.localizedDescription
            case .success(()):
                if !self.goal.isSubGoal {
                    for goal in self.goalService.getSubGoals(mainGoal: self.goal) {
                        self.goalService.deleteGoal(goal: goal) {_ in}
                    }
                }else {
                    CalcService.shared.calcProgress(for: self.mainGoal)
                }
                self.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
