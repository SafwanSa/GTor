//
//  ProfileView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct Setting: Identifiable {
    var id = UUID()
    var text: String
    var isHavingDestination: Bool
    var destination: AnyView?
}

let typicalSettings: [Setting] = [
    .init(text: "Rate GTor", isHavingDestination: false),
    .init(text: "Share GTor", isHavingDestination: false),
    .init(text: "About GTor", isHavingDestination: true)
]
let appSettings: [Setting] = [
    .init(text: "Tags Settings", isHavingDestination: true)
]
let actionSettings: [Setting] = [
    .init(text: "Logout", isHavingDestination: false),
    .init(text: "Delete Account", isHavingDestination: false)
]

struct HomeScreenView: View {
    @ObservedObject var userService = UserService.shared
    @ObservedObject var taskService = TaskService.shared
    @State var selectedDate: Date = Date()
    @State var isShowingDashboard = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                Color(UIColor.clear).frame(height: 330)
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
                .padding(.bottom, 20)
            }
            
            VStack {
                HeaderHomeView(isShowingDashboard: $isShowingDashboard)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
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
                Image("female-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 238, height: 144)
                Text(userService.user.name)
                    .font(.system(size: 18))
                Text(userService.user.email)
                    .font(.system(size: 12))
                
                HStack {
                    Text("DASHBOARD")
                    .onTapGesture {
                        self.isShowingDashboard = true
                    }
                    .foregroundColor(Color(isShowingDashboard ? "Button" : "Primary"))
                    Spacer()
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
            .padding(.horizontal, 45)
            .padding(.vertical, 22)
            .padding(.top, 35)
            .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9960784314, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 7)
        }
    }
}

struct CurrentTasksView: View {
    @ObservedObject var taskService = TaskService.shared
    @State var selectedDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 27.0) {
//            DaysCardView(selectedDate: $selectedDate)
            
            ForEach(taskService.tasks.filter { !$0.isSatisfied && ($0.dueDate == nil ? true : $0.dueDate!.fullDate == self.selectedDate.fullDate) }) { task in
                NewTaskCardView(task: task, selectedTask: .constant(Task.dummy))
                    .padding(.horizontal)
            }
        }
    }
}

struct SettingsRowButtonView: View {
    var text: String
    var isHavingDestination: Bool
    
    var body: some View {
        VStack(spacing: 27.0) {
                HStack {
                    Text(text)
                    Spacer()
                    Image(systemName: "chevron.right").opacity(isHavingDestination ? 1 : 0)
                }
                .padding(.vertical)
                .padding(.horizontal, 22)
                .background(Color(text == "Delete Account" ? "Level 3" : "Level 0"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .elevation()
                .foregroundColor(Color("Primary"))
        }
        .foregroundColor(Color("Primary"))
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20.0) {
                ForEach(appSettings) { setting in
                    SettingsRowButtonView(text: setting.text, isHavingDestination: setting.isHavingDestination)
                }
            }
            
            VStack(spacing: 20.0) {
                ForEach(typicalSettings) { setting in
                    SettingsRowButtonView(text: setting.text, isHavingDestination: setting.isHavingDestination)
                }
            }
            
            VStack(spacing: 20.0) {
                ForEach(actionSettings) { setting in
                    SettingsRowButtonView(text: setting.text, isHavingDestination: setting.isHavingDestination)
                }
            }
            
            
        }.padding(.horizontal)
    }
}
