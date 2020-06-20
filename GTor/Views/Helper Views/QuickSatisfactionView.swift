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
}


let actions: [DoneAction] = [
    .init(title: "Completly Done", satisfaction: 100),
    .init(title: "Ignored", satisfaction: 0),
    .init(title: "Partially Done", satisfaction: 50)//TODO
]

struct QuickSatisfactionView: View {
    @ObservedObject var taskService = TaskService.shared
    @Binding var isSatisfiedPresnted: Bool
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
                    Button(action: { self.isSatisfiedPresnted = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                
                VStack(spacing: 20.0) {
                    if self.isHidingTextField {
                        ForEach(actions, id: \.self) { action in
                            VStack {
                                Button(
                                    action: {
                                        if action.title != "Partially Done" {
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
                                                    self.isSatisfiedPresnted = false
                                                }
                                            }
                                        }else {
                                            self.isHidingTextField = false
                                        }
                                }) {
                                    Text(action.title)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 20)
                                        .padding(8)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }else {
                        VStack {
                            TextField("50%", text: $updatedSatisfaction)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                                .keyboardType(.asciiCapableNumberPad)
                                .background(Color(UIColor.systemBackground))
                                .multilineTextAlignment(.center)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            Button(action: {
                                self.isLoading = true
                                if self.updatedSatisfaction.isEmpty {
                                    self.isLoading = false
                                    self.isShowingAlert = true
                                    self.alertMessage = "Please enter a value"
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
                                        self.isSatisfiedPresnted = false
                                        self.isHidingTextField = true
                                        self.updatedSatisfaction = ""
                                    }
                                }
                            }) {
                                Text("Done")
                                .frame(maxWidth: .infinity)
                                .frame(height: 20)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .animation(.spring())
                    }
                }
                .padding()
                
                
            }
            .frame(width: 200, height: 200)
            .padding()
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.easeInOut)
            .offset(y: isSatisfiedPresnted ? 0 : screen.height)
            
            LoadingView(isLoading: $isLoading)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text(self.alertMessage))
        }
    }
}


struct QuickSatisfactionView_Previews: PreviewProvider {
    static var previews: some View {
        QuickSatisfactionView(isSatisfiedPresnted: .constant(true), selectedTask: .constant(.dummy))
    }
}
