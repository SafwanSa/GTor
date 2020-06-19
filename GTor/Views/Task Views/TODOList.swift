//
//  TODOList.swift
//  GTor
//
//  Created by Safwan Saigh on 21/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TODOList: View {
    @ObservedObject var taskService = TaskService.shared
    @State var isAddTaskSelected = false
    @State var isSatisfiedPresnted = false
    @State var selectedTask = Task.dummy
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20.0) {
                        ForEach(taskService.tasks.filter {!$0.isSatisfied}) { task in
                            NavigationLink(destination: TaskView(task: task)) {
                                TaskCardView(task: task, isSatisfiedPresnted: self.$isSatisfiedPresnted, selectedTask: self.$selectedTask)
                            }
                        }
                        Text("Done tasks")
                        ForEach(taskService.tasks.filter {$0.isSatisfied} ) { task in
                            NavigationLink(destination: TaskView(task: task)) {
                                TaskCardView(task: task, isSatisfiedPresnted: self.$isSatisfiedPresnted, selectedTask: self.$selectedTask)
                            }
                        }
                    }
                    .blur(radius: isSatisfiedPresnted ? 2: 0)
                    .sheet(isPresented: $isAddTaskSelected) {
                        AddTaskView()
                    }
                }
                .navigationBarItems(trailing:
                    HStack(spacing: 20) {
                        Button(action: {  }) {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                .font(.headline)
                        }
                        Button(action: { self.isAddTaskSelected = true }) {
                            Image(systemName: "plus")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                                .font(.headline)
                        }
                    }
                    .blur(radius: isSatisfiedPresnted ? 2: 0)
                )
                QuickSatisfactionView(isSatisfiedPresnted: $isSatisfiedPresnted, selectedTask: $selectedTask)
            }
            .navigationBarTitle("TODO")
        }
    }
}
struct TODOList_Previews: PreviewProvider {
    static var previews: some View {
        TODOList()
    }
}
