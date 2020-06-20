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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10.0) {
                        TODOView(isSatisfiedPresnted: $isSatisfiedPresnted, selectedTask: $selectedTask, title: .constant("Running Task"), tasksList: taskService.tasks.filter {!$0.isSatisfied})
                        
                        TODOView(isSatisfiedPresnted: $isSatisfiedPresnted, selectedTask: $selectedTask, title: .constant("Done Task"), tasksList: taskService.tasks.filter {$0.isSatisfied})
                        
//                        TODOView(isSatisfiedPresnted: $isSatisfiedPresnted, selectedTask: $selectedTask, title: .constant("Today"), tasksList: taskService.tasks.filter {$0.dueDate != nil}.filter {dateFormatter2.string(from: $0.dueDate!) == dateFormatter2.string(from: Date())})
                    
                    }
                }
                
                QuickSatisfactionView(isSatisfiedPresnted: $isSatisfiedPresnted, selectedTask: $selectedTask)
            }
            .sheet(isPresented: $isAddTaskSelected) {
                AddTaskView()
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
                .navigationBarTitle("TODO")
        }
    }
}
struct TODOList_Previews: PreviewProvider {
    static var previews: some View {
        TODOList()
    }
}

struct TODOView: View {
    @Binding var isSatisfiedPresnted: Bool
    @Binding var selectedTask: Task
    @Binding var title: String
    
    var tasksList: [Task]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20.0) {
                HStack {
                    Text(title)
                        .font(.system(size: 23)).bold()
                    Spacer()
                }
                .padding()
                .padding(.leading, 10)
                
                ForEach(tasksList) { task in
                    NavigationLink(destination: TaskView(task: task)) {
                        TaskCardView(task: task, isSatisfiedPresnted: self.$isSatisfiedPresnted, selectedTask: self.$selectedTask)
                            .padding(.horizontal)
                    }
                }
            }
            .blur(radius: isSatisfiedPresnted ? 2: 0)
        }
    }
}
