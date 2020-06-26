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
                    
                    Spacer()
                    
                    Image(systemName: task.isSatisfied ? "checkmark.square" :"square")
                        .onTapGesture {
                            self.isSatisfiedPresnted = true
                            self.selectedTask = self.task
                    }
                }
                .foregroundColor(Color.black)
                
                Spacer()
                
                Text("\(task.dueDate ?? Date(), formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(Color("Level 3"))
            }
            .frame(width: screen.width - 80, alignment: .leading)
            .frame(maxHeight: 85)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color("Level 2"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow()
        }
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: .dummy, isSatisfiedPresnted: .constant(false), selectedTask: .constant(.dummy))
    }
}
