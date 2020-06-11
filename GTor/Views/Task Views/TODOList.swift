//
//  TODOList.swift
//  GTor
//
//  Created by Safwan Saigh on 21/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TODOList: View {
    @State var tasks = tasksData
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20.0) {
                        ForEach(tasks) { task in
                            NavigationLink(destination: TaskView()) {
                                TaskCardView(task: task)
                            }
                        }
                    }
                }
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
let tasksData: [Task] = [
    .init(title: "Do Louandry", note: "Just white T-shirts", dueDate: Date(), importance: .important, satisfaction: 0, isSatisfied: false),
    .init(title: "Homework", note: "Chapter 1", dueDate: Date(), importance: .veryImportant, satisfaction: 0, isSatisfied: false),
    .init(title: "Pay for the match", dueDate: Date(), importance: .notImportant, satisfaction: 0, isSatisfied: false)
]
