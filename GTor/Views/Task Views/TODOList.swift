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
    @State var isSatisfiedPresented = false
    @State var selectedTask = Task.dummy
    @State var title = "To do"
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Level 0")
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text(title)
                                .font(.system(size: 23)).bold()
                            Spacer()
                        }
                        .padding()
                        .padding(.leading, 10)
                        
                        ForEach(taskService.tasks) { task in
                            NavigationLink(destination: TaskView(task: task)) {
                                TaskCardView(task: task, isSatisfiedPresnted: self.$isSatisfiedPresented, selectedTask: self.$selectedTask)
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                    .blur(radius: isSatisfiedPresented ? 2: 0)
                }
                
                QuickSatisfactionView(isSatisfiedPresnted: $isSatisfiedPresented, selectedTask: $selectedTask)
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
                            .foregroundColor(Color("Level 3"))
                            .font(.headline)
                    }.opacity(0)//TODO
                    Button(action: { self.isAddTaskSelected = true }) {
                        Image(systemName: "plus")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(Color("Level 3"))
                            .font(.headline)
                    }
                }
                .blur(radius: isSatisfiedPresented ? 2: 0)
            )
                .navigationBarTitle("Tasks", displayMode: .inline)
        }
    }
}
struct TODOList_Previews: PreviewProvider {
    static var previews: some View {
        TODOList()
    }
}
