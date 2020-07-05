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
    @State var isFilterViewPresented = false
    @State var currentFilter = FilterType.todo
    @State var currentSorter = SorterType.ImportantFirst
    var filteredTasks: [Task] {
        switch currentFilter {
        case .todo:
            return self.taskService.tasks.filter { !$0.isSatisfied }
        case .completelyDone:
            return self.taskService.tasks.filter { $0.satisfaction == 100 }
        case .partiallyDone:
            return self.taskService.tasks.filter { $0.satisfaction < 100 && $0.satisfaction > 0 }
        case .ignored:
            return self.taskService.tasks.filter { $0.satisfaction == 0 }
        }
    }
    
    var sortedTasks: [Task] {
        switch currentSorter {
        case .newestFirst:
            return self.filteredTasks.sorted { $0.dueDate == nil || $1.dueDate == nil ? false : $0.dueDate! > $1.dueDate! }
        case .oldestFirst:
            return self.filteredTasks.sorted { $0.dueDate == nil || $1.dueDate == nil ? false : $0.dueDate! < $1.dueDate! }
        case .ImportantFirst:
            return self.filteredTasks.sorted { $0.importance.value > $1.importance.value }
        case .NotImportantFirst:
            return self.filteredTasks.sorted { $0.importance.value < $1.importance.value }
        }
    }
    
    
    var title: String {
        currentFilter.rawValue
    }
    
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
                        
                        ForEach(sortedTasks) { task in
                            NavigationLink(destination: TaskView(task: task)) {
                                TaskCardView(task: task, isSatisfiedPresnted: self.$isSatisfiedPresented, selectedTask: self.$selectedTask)
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                    .blur(radius: isSatisfiedPresented || isFilterViewPresented ? 2: 0)
                    .disabled(isSatisfiedPresented || isFilterViewPresented)
                    .onTapGesture {
                        self.isFilterViewPresented = false
                        self.isSatisfiedPresented = false
                    }
                }
                
                QuickSatisfactionView(isSatisfiedPresnted: $isSatisfiedPresented, selectedTask: $selectedTask)
                
                
                VStack {
                    List {
                        Section(header: Text("Filter By")) {
                            ForEach(FilterType.allCases, id: \.self) { filter in
                                Button(action: {
                                    self.currentFilter = filter
                                    self.isFilterViewPresented = false
                                }) {
                                    HStack {
                                        Text(filter.rawValue)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color("Level 4"))
                                            .opacity(filter == self.currentFilter ? 1 : 0)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        Section(header: Text("Sort By")) {
                            ForEach(SorterType.allCases, id: \.self) { sorter in
                                Button(action: {
                                    self.currentSorter = sorter
                                    self.isFilterViewPresented = false
                                }) {
                                    HStack {
                                        Text(sorter.rawValue)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color("Level 4"))
                                            .opacity(sorter == self.currentSorter ? 1 : 0)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    
                }
                .frame(maxWidth: screen.width - 80)
                .frame(height: screen.height - 250)
                .background(Color("Level 1"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.spring())
                .offset(y: isFilterViewPresented ? 0 : screen.height)
                
                
            }
            .sheet(isPresented: $isAddTaskSelected) {
                AddTaskView()
            }
            .navigationBarItems(trailing:
                HStack(spacing: 20) {
                    Button(action: { self.isFilterViewPresented = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(Color("Level 3"))
                            .font(.headline)
                    }
                    Button(action: { self.isAddTaskSelected = true }) {
                        Image(systemName: "plus")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(Color("Level 3"))
                            .font(.headline)
                    }
                }
                .blur(radius:isSatisfiedPresented || isFilterViewPresented ? 2: 0)
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

enum FilterType: String, CaseIterable {
    case todo = "To-do"
    case completelyDone = "Completely Done"
    case ignored = "Ignored"
    case partiallyDone = "Partially Done"
}

enum SorterType: String, CaseIterable {
    case oldestFirst = "Deadline - Ascending"
    case newestFirst = "Deadline - Descending"
    case ImportantFirst = "Importance - High to low"
    case NotImportantFirst = "Importance - Low to High"
}
