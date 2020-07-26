//
//  NewTODOListView.swift
//  GTor
//
//  Created by Safwan Saigh on 26/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

enum DateClipType {
    case num, char
}

struct NewTODOListView: View {
    @ObservedObject var taskService = TaskService.shared
    @State var isAddTaskSelected = false
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12.0) {
                    TODOView()
                    
                    RowListView(title: "completed", tasks: taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 100 })
                    
                    RowListView(title: "partially completed", tasks: taskService.tasks.filter { $0.isSatisfied && ($0.satisfaction < 100 && $0.satisfaction > 0) })
                    
                    RowListView(title: "ignored", tasks: taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 0 })
                }
            }
            .padding(.top, 20)
            .navigationBarTitle("My Tasks", displayMode: .inline)
            .navigationBarItems(trailing:
            Button(action: { self.isAddTaskSelected = true }) {
                Image(systemName: "plus")
                    .foregroundColor(Color("Button"))
            }
            .sheet(isPresented: $isAddTaskSelected) {
                AddTaskView()
            }
            )
        }
        
    }
    
    
    
}

struct NewTODOListView_Previews: PreviewProvider {
    static var previews: some View {
        NewTODOListView()
    }
}

struct DaysCardView: View {
    @State var dates: [Date] = [Date()]
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedDate == dates[0] ? "Today" : "\(String(selectedDate.fullDate.split(separator: ",")[0]))")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Text(selectedDate == dates[0] ? "\(String(selectedDate.fullDate.split(separator: ",")[0])) | \(String(selectedDate.fullDate.split(separator: ",")[1])), \(String(selectedDate.fullDate.split(separator: ",")[2]))" :
                    "\(selectedDate, formatter: dateFormatter2)")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(Color("Primary"))
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14.0) {
                    ForEach(dates, id: \.self) { date in
                        VStack(spacing: 7.0) {
                            Text("\(self.clipDate(date: date, clipType: .num))")
                            Text("\(self.clipDate(date: date, clipType: .char))")
                        }
                        .foregroundColor(Color("Primary"))
                        .font(.system(size: 14))
                        .frame(minWidth: 64)
                        .frame(height: 70, alignment: .center)
                        .background(Color(date == self.selectedDate ? "Button" : "Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .elevation()
                        .onTapGesture {
                            self.selectedDate = date
                        }
                    }
                }
                .padding(4)
                .onAppear {
                    self.selectedDate = self.dates[0]
                    self.generateDates()
                }
            }
        }
    }
    
    func generateDates() {
        for i in 1...2*10 {
            dates.append(Date().addingTimeInterval(TimeInterval(60*60*24*i)))
        }
    }
    
    func clipDate(date: Date, clipType: DateClipType) -> String {
        let str = dateFormatter.string(from: date)
        switch clipType {
        case .char:
            let index = str.index(str.startIndex, offsetBy: 3)
            return String(str[..<index])
        case .num:
            let str = str.split(separator: ",")[1].split(separator: " ")[1]
            return String(str)
        }
    }
}

struct TODOView: View {
    @ObservedObject var taskService = TaskService.shared
    @State var isAddTaskSelected = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("TODO")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color("Primary"))
                .padding(.horizontal)
            
            ForEach(taskService.tasks.filter { !$0.isSatisfied }) { task in
                NavigationLink(destination: TaskView(task: task)) {
                    TaskCardView(task: task,
                                 isSatisfiedPresnted: .constant(false),
                                 selectedTask: .constant(.dummy))
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct RowListView: View {
    var title: String
    var tasks: [Task]
    @State var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .frame(width: 15)
                    .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
                    .animation(.linear)
                
                Text(title)
                
            }
            .foregroundColor(Color("Primary"))
            .font(.system(size: 14))
            .padding(6)
            .background(Color("Button"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                self.isExpanded.toggle()
            }
            VStack {
                if isExpanded { ForEach(tasks) { task in
                    NavigationLink(destination: TaskView(task: task)) {
                        TaskCardView(task: task,
                                     isSatisfiedPresnted: .constant(false),
                                     selectedTask: .constant(.dummy))
                    }
                    }
                }
            }
            .animation(.easeInOut)
        }
        .padding(.horizontal)
    }
}
