//
//  TaskView.swift
//  GTor
//
//  Created by Safwan Saigh on 11/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    @State var updatedTitle = ""
    @State var updatedNote = ""
    @State var satisfaction = ""
    
    
    var body: some View {
        List {
            Section {
                TextField(task.title, text: $updatedTitle)
                TextField(task.note ?? "Note (Optional)", text: $updatedNote)
            }
            
            if task.dueDate != nil {
                Section {
                    HStack {
                        Text("Due")
                        Spacer()
                        Text("\(task.dueDate!, formatter: dateFormatter)")
                    }
                }
            }
            
            Section(header: Text("Linked Goals")) {
                ForEach(task.linkedGoals!) { linkedGoal in
                    Text(linkedGoal.title ?? "")
                }
            }

            
            Section {
                HStack {
                    Text("Done")
                    Spacer()
                    TextField("100%", text: $satisfaction)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Edit Task", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: { /*Save*/ }) {
                Text("Done")
            }
        )
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .dummy)
    }
}
