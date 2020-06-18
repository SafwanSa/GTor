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

    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20.0) {
                        ForEach(taskService.tasks) { task in
                            NavigationLink(destination: TaskView(task: task)) {
                                TaskCardView(task: task)
                            }
                        }
                    }
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
                )
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

struct TaskCardView: View {
    var task: Task
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(task.dueDate ?? Date(), formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: screen.width - 80, alignment: .leading)
            .frame(maxHeight: 85)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                HStack {
                    Color.red
                        .frame(width: 5)
                        .frame(maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    Spacer()
            })
        }
    }
}

