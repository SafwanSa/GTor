//
//  TaskCardView.swift
//  GTor
//
//  Created by Safwan Saigh on 19/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TaskCardView: View {
    var task: Task
    @Binding var isSatisfiedPresnted: Bool
    @Binding var selectedTask: Task
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: task.isSatisfied ? "checkmark.square" :"square")
                        .onTapGesture {
                            self.isSatisfiedPresnted = true
                            self.selectedTask = self.task
                    }
                    
                }
                
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

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: .dummy, isSatisfiedPresnted: .constant(false), selectedTask: .constant(.dummy))
    }
}
