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
    @ObservedObject var userService = UserService.shared
    @ObservedObject var taskService = TaskService.shared
    @State var isAddTaskSelected = false
    @State var selectedTask = Task.dummy
    
    var isShowingComplete: Bool {
        !taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 100 }.isEmpty
    }
    var isShowingPComplete: Bool {
        !taskService.tasks.filter { $0.isSatisfied && ($0.satisfaction < 100 && $0.satisfaction > 0) }.isEmpty
    }
    var isShowingNComplete: Bool {
        !taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 0 }.isEmpty
    }
    
    var isShowingTODO: Bool {
        !taskService.tasks.filter { !$0.isSatisfied }.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: false) {
                    if taskService.tasks.isEmpty {
                        NoDataView(title: NSLocalizedString("youDontHaveTasks", comment: ""), actionTitle: NSLocalizedString("let'sAddOne", comment: ""), action: { self.isAddTaskSelected = true })
                    }
                    VStack(alignment: .leading, spacing: 12.0) {
                        if !taskService.tasks.isEmpty {
                            
                            if isShowingTODO { TODOView(selectedTask: $selectedTask) }
                            
                            if isShowingComplete {
                                RowListView(title: NSLocalizedString("completed", comment: ""), tasks: taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 100 }, selectedTask: $selectedTask)
                            }
                            if isShowingPComplete {
                                RowListView(title: NSLocalizedString("partially completed", comment: ""), tasks: taskService.tasks.filter { $0.isSatisfied && ($0.satisfaction < 100 && $0.satisfaction > 0) }, selectedTask: $selectedTask)
                            }
                            if isShowingNComplete {
                                RowListView(title: NSLocalizedString("not completed", comment: ""), tasks: taskService.tasks.filter { $0.isSatisfied && $0.satisfaction == 0 }, selectedTask: $selectedTask)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 20)
                .navigationBarTitle("\(NSLocalizedString("tasks", comment: ""))", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: { self.isAddTaskSelected = true }) {
                        Image(systemName: "plus")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(Color("Button"))
                            .font(.headline)
                    }
                    .sheet(isPresented: $isAddTaskSelected) {
                        NewAddTaskView(task: .init(uid: self.userService.user.uid,
                                                   title: "",
                                                   note: "",
                                                   satisfaction: 0,
                                                   isSatisfied: false,
                                                   linkedGoalsIds: [],
                                                   importance: .normal))
                    }
                )
                    .blur(radius: selectedTask == Task.dummy ? 0 : 2)
                    .disabled(selectedTask != Task.dummy)
                
                QuickSatisfactionView(selectedTask: $selectedTask)
            }
        }
    }
}

struct NewTODOListView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskCardView(task: Task.dummy, selectedTask: .constant(.dummy))
    }
}

struct DaysCardView: View {
    @State var dates: [Date] = []
    @Binding var selectedDate: Date
    
    var dateTitle: String {
        if currentLanguage == "ar" {
            return selectedDate == dates[dates.count-1] ? NSLocalizedString("today", comment: "") : "\(String(selectedDate.fullDate.split(separator: ",")[0]))"
            
        }else {
            return selectedDate == dates[0] ? NSLocalizedString("today", comment: "") : "\(String(selectedDate.fullDate.split(separator: ",")[0]))"
        }
    }
    var body: some View {
        VStack {
            if dates.isEmpty {
                Text("Loading...")
            }else {
                HStack {
                    Text(dateTitle)
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    Text(selectedDate == dates[0] ? "\(String(selectedDate.fullDate.split(separator: ",")[0])) | \(String(selectedDate.fullDate.split(separator: ",")[1])), \(String(selectedDate.fullDate.split(separator: ",")[2]))" :
                        "\(selectedDate, formatter: dateFormatter2)")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(Color("Primary"))
                .padding(.horizontal)
                .animation(nil)
                
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
                }
            }
            
            
        }
        .onAppear {
            self.generateDates()
            self.selectedDate = currentLanguage == "ar" ? self.dates[self.dates.count-1] : self.dates[0]
        }
    }
    
    func generateDates() {
        if currentLanguage == "ar" {
            var counter = 90
            while counter != -1 {
                dates.append(Date().addingTimeInterval(TimeInterval(60*60*24*counter)))
                counter -= 1
            }
        }else {
            for i in 0...90 {
                dates.append(Date().addingTimeInterval(TimeInterval(60*60*24*i)))
            }
        }
    }
    
    func clipDate(date: Date, clipType: DateClipType) -> String {
        if currentLanguage == "ar" {
            let str = dateFormatter.string(from: date)
            switch clipType {
            case .char:
                let str = str.split(separator: "،")[0]
                return String(str)
            case .num:
                let str = str.split(separator: "،")[1].split(separator: " ")[0]
                return String(str)
            }
        }else {
            let str = dateFormatter.string(from: date)
            switch clipType {
            case .char:
                let index = str.index(str.startIndex, offsetBy: 3)
                return String(str[..<index])
            case .num:
                let str = str.split(separator: ",")[1].split(separator: " ")[0]
                return String(str)
            }
        }
    }
}

struct TODOView: View {
    @ObservedObject var taskService = TaskService.shared
    @Binding var selectedTask: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("todo", comment: ""))
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color("Primary"))
                .padding(.horizontal)
            
            ForEach(taskService.tasks.filter { !$0.isSatisfied }) { task in
                NavigationLink(destination: NewTaskView(task: task)) {
                    NewTaskCardView(task: task,
                                    selectedTask: self.$selectedTask)
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
    @Binding var selectedTask: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: NSLocalizedString("chevron", comment: ""))
                    .font(.system(size: 13))
                    .frame(width: 15)
                    .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
                    .animation(.linear)
                
                Text("\(tasks.count) \(title)")
                
            }
            .foregroundColor(Color("Primary"))
            .font(.system(size: 14))
            .padding(6)
            .background(Color("Button"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                self.isExpanded.toggle()
            }
            .padding(.horizontal)
            VStack {
                if isExpanded {
                    ForEach(tasks) { task in
                        NavigationLink(destination: NewTaskView(task: task)) {
                            NewTaskCardView(task: task,
                                            selectedTask: self.$selectedTask)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .animation(Animation.easeInOut)
        }
    }
}

struct NewTaskCardView: View {
    var task: Task
    @Binding var selectedTask: Task
    
    var body: some View {
        HStack(spacing: 12.0) {
            Button(action: {
                self.selectedTask = self.task
            }) {
                Image(systemName: task.isSatisfied ? "circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Text(task.title)
                .strikethrough(task.isSatisfied, color: Color("Primary"))
                .font(.system(size: 15))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(NSLocalizedString(task.importance.rawValue.lowercased(), comment: ""))
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color("Secondry").opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .elevation()
                
                if task.dueDate != nil {
                    Spacer()
                    Text("\(task.dueDate!, formatter: dateFormatter2)")
                        .foregroundColor(Color("Secondry"))
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(Color("Primary"))
        }
        .frame(height: 45)
        .padding(.vertical, 4)
        .padding(.leading, 10)
        .padding(.trailing, 3)
        .background(Color("Level 0"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
    }
}
