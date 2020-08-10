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
            .navigationBarTitle("\(NSLocalizedString("Goal", comment: ""))", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: saveGoal) {
                    Text(NSLocalizedString("Save", comment: ""))
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
                    Text(NSLocalizedString("Edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingTitleEditor) {
                    TextEditorView(title: NSLocalizedString("Edit Title", comment: ""), text: self.$goal.title)
                }
            }
            
            Color("Secondry")
                .frame(height: 1)
            
            HStack {
                Text(goal.note.isEmpty ? NSLocalizedString("Empty Note", comment: "") : goal.note)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: { self.isShowingNoteEditor = true }) {
                    Text(NSLocalizedString("Edit", comment: ""))
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                }
                .sheet(isPresented: $isShowingNoteEditor) {
                    TextEditorView(title: NSLocalizedString("Edit Note", comment: ""), text: self.$goal.note)
                }
            }
        }
        .foregroundColor(Color("Primary"))
        .padding(.vertical)
        .padding(.horizontal, 22)
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .elevation()
        .overlay(
            ProgressBar(value: self.goal.satisfaction/100)
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
                        Text(date != nil ? "\(date!, formatter: dateFormatter2)" : "\(NSLocalizedString("No deadline", comment: ""))")
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text(NSLocalizedString("Edit", comment: ""))
                                .foregroundColor(Color("Button"))
                                .font(.callout)
                        }
                        .opacity(0)//TODO

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
                    Text(NSLocalizedString("Sub Goals", comment: ""))
                    Spacer()
                    Image(systemName: NSLocalizedString("chevron.right", comment: ""))
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
                    Text(NSLocalizedString("Linked Tasks", comment: ""))
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
                    Text(NSLocalizedString("Tags", comment: ""))
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
                    Text(NSLocalizedString("Delete Goal", comment: ""))
                    Spacer()
                }
            ), backgroundColor: Color(.white), foregroundColor: Color("Primary"), action: { self.isShowingDeleteAlert = true })
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text(NSLocalizedString("Are you sure you want to delete this goal?", comment: "")),
                  message: Text(self.goal.isDecomposed ? NSLocalizedString("All the Sub Goals of this goal will be deleted also", comment: "") : ""),
                  primaryButton: .default(Text(NSLocalizedString("Cancel", comment: ""))),
                  secondaryButton: .destructive(Text(NSLocalizedString("Delete", comment: "")), action: deleteGoal))
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
