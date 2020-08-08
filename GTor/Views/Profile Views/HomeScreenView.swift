//
//  ProfileView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var taskService = TaskService.shared
    @State var selectedDate: Date = Date()
    @State var isShowingDashboard = true
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HeaderHomeView(isShowingDashboard: $isShowingDashboard)
                
                VStack(spacing: 27.0) {
                    HStack {
                        Group {
                            if isShowingDashboard {
                                CurrentTasksView()
                            }else {
                                SettingsView()
                                    .animation(nil)
                            }
                        }
                    }
                    .transition(.slide)
                    .animation(.spring())
                }
                .padding(.vertical, 20)
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

struct HeaderHomeView: View {
    @ObservedObject var userService = UserService.shared
    @Binding var isShowingDashboard: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Hello,")
                            .font(.system(size: 18))
                        Text(userService.user.name)
                            .font(.system(size: 18))
                        Text(userService.user.email)
                            .font(.system(size: 12))
                    }
                    Spacer()
                    Image("female-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 162, height: 78)
                        .offset(x: 48, y: -10)
                }
                
                
                
                HStack(spacing: 70.0) {
                    Text("DASHBOARD")
                        .onTapGesture {
                            self.isShowingDashboard = true
                    }
                    .foregroundColor(Color(isShowingDashboard ? "Button" : "Primary"))
                    
                    Text("SETTINGS")
                        .onTapGesture {
                            self.isShowingDashboard = false
                    }
                    .foregroundColor(Color(isShowingDashboard ? "Primary" : "Button"))
                }
                .font(.system(size: 14))
                .padding(.top, 25)
            }
            .foregroundColor(Color("Primary"))
            .padding(.horizontal, 29)
            .padding(.vertical, 22)
            .padding(.top, 35)
            .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9960784314, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 7)
        }
    }
}

struct CurrentTasksView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var taskService = TaskService.shared
    @State var selectedDate: Date = Date()
    @State var isShowingAddTask = false
    @State var selectedTask: Task = .dummy
    
    var tasks: [Task] {
        taskService.tasks.filter { !$0.isSatisfied && ($0.dueDate == nil ? true : $0.dueDate!.fullDate == self.selectedDate.fullDate) }
    }
    
    var isShowingTasks: Bool {
        !tasks.isEmpty
    }
    var body: some View {
        ZStack {
            VStack(spacing: 27.0) {
                DaysCardView(selectedDate: $selectedDate).padding(.leading, 4)
                
                if isShowingTasks{
                    ForEach(tasks) { task in
                        NewTaskCardView(task: task, selectedTask: self.$selectedTask)
                            .padding(.horizontal)
                    }
                }else {
                    NoTaskView(title: "You do not have tasks on this day. ", actionTitle: "Add Task", action: { self.isShowingAddTask = true })
                }
            }
            .sheet(isPresented: $isShowingAddTask) {
                NewAddTaskView(task: .init(uid: self.userService.user.uid,
                                           title: "",
                                           note: "",
                                           satisfaction: 0,
                                           isSatisfied: false,
                                           linkedGoalsIds: [],
                                           importance: .normal),
                               deadline: self.selectedDate, isHavingDeadline: true)
            }
            .blur(radius: selectedTask == Task.dummy ? 0 : 2)
            .disabled(selectedTask != Task.dummy)
            
            QuickSatisfactionView(selectedTask: $selectedTask)
        }
    }
}

struct NoTaskView: View {
    var title: String
    var actionTitle: String
    var action: () -> ()
    
    var body: some View {
        VStack(spacing: 15.0) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color.secondary)
            Button(action: action) {
                Text(actionTitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color("Primary"))
                    .padding(.vertical, 13)
                    .padding(.horizontal, 20)
            }
            .background(Color("Button"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .opacity(0.8)
        .padding(.top)
    }
}
