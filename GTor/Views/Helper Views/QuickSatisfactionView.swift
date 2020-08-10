//
//  QuickSatisfactionView.swift
//  GTor
//
//  Created by Safwan Saigh on 19/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct DoneAction: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var satisfaction: Double
    var type: ActionType
}

enum ActionType {
    case complete, pComplete, notComplete
}

let actions: [DoneAction] = [
    .init(title: NSLocalizedString("Completely Done", comment: ""), satisfaction: 100, type: .complete),
    .init(title: NSLocalizedString("Partially Done", comment: ""), satisfaction: 50, type: .pComplete),//TODO
    .init(title: NSLocalizedString("Not Done", comment: ""), satisfaction: 0, type: .notComplete)
]

struct QuickSatisfactionView: View {
    @ObservedObject var taskService = TaskService.shared
    @Binding var selectedTask: Task
    @State var updatedSatisfaction = ""
    @State var isHidingTextField = true
    
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { self.selectedTask = Task.dummy; self.isHidingTextField = true }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color("Primary"))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: -8)
                    Spacer()
                }
                Spacer()
                VStack(spacing: 10.0) {
                    if self.isHidingTextField {
                        ForEach(actions, id: \.self) { action in
                            VStack {
                                Button(
                                    action: {
                                        if action.type != .pComplete {
                                            self.isLoading = true
                                            self.selectedTask.satisfaction = action.satisfaction
                                            self.selectedTask.isSatisfied = true
                                            self.taskService.saveTask(task: self.selectedTask) { result in
                                                switch result {
                                                case .failure(let error):
                                                    self.isLoading = false
                                                    self.isShowingAlert = true
                                                    self.alertMessage = error.localizedDescription
                                                case .success(()):
                                                    self.isLoading = false
                                                    self.selectedTask = Task.dummy
                                                }
                                            }
                                        }else {
                                            self.isHidingTextField = false
                                        }
                                }) {
                                    Text(action.title)
                                        .font(.system(size: 13))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 20)
                                        .padding(7)
                                        .foregroundColor(Color.black)
                                        .background(Color("Button"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }else {
                        VStack {
                            TextField("50%", text: $updatedSatisfaction)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity)
                                .frame(height: 20)
                                .padding(7)
                                .foregroundColor(Color.black)
                                .background(Color("Level 0"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .elevation()
                            
                            Spacer()
                            Button(action: {
                                self.isLoading = true
                                if self.updatedSatisfaction.isEmpty {
                                    self.isLoading = false
                                    self.isShowingAlert = true
                                    self.alertMessage = NSLocalizedString("Please enter a value", comment: "")
                                    return
                                }else{
                                    self.selectedTask.satisfaction = Double(self.updatedSatisfaction)!
                                }
                                self.selectedTask.isSatisfied = true
                                self.taskService.saveTask(task: self.selectedTask) { result in
                                    switch result {
                                    case .failure(let error):
                                        self.isLoading = false
                                        self.isShowingAlert = true
                                        self.alertMessage = error.localizedDescription
                                    case .success(()):
                                        self.isLoading = false
                                        self.selectedTask = Task.dummy
                                        self.isHidingTextField = true
                                        self.updatedSatisfaction = ""
                                    }
                                }
                            }) {
                                Text(NSLocalizedString("Done", comment: ""))
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity)
                                .frame(height: 20)
                                .padding(7)
                                .foregroundColor(Color.black)
                                .background(Color("Button"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .animation(.spring())
                    }
                }
                .padding()
                
                
            }
            .frame(width: 200, height: 170)
            .padding()
            .background(Color("Level 0"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .elevation()
            .animation(.easeInOut)
            .offset(y: self.selectedTask != Task.dummy ? 0 : screen.height)
            
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
}


struct QuickSatisfactionView_Previews: PreviewProvider {
    static var previews: some View {
        QuickSatisfactionView(selectedTask: .constant(.init(uid: "", title: "Ti", note: "", satisfaction: 0, isSatisfied: false, linkedGoalsIds: [], importance: .none)))
    }
}
