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
    @State var alertMessage = ""
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Color.primary.opacity(0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(spacing: 20.0) {
                        HStack {
                            Button(action: { self.isSatisfiedPresnted = false }) {
                                Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .foregroundColor(Color(UIColor.systemBackground))
                        ForEach(actions, id: \.self) { action in
                            VStack {
                                Color.primary
                                    .frame(width: 180, height: 1)
                                
                                Button(
                                    action: {
                                        self.isLoading = true
                                        if action.title != "Partially Done" {
                                            self.selectedTask.satisfaction = action.satisfaction
                                        }else {
                                            if self.updatedSatisfaction.isEmpty {
                                                self.isLoading = false
                                                self.isShowingAlert = true
                                                self.alertMessage = "Please enter a value"
                                                return
                                            }else{
                                                self.selectedTask.satisfaction = Double(self.updatedSatisfaction)!
                                            }
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
                                            }
                                        }
                                }) {
                                    VStack {
                                        Text(action.title)
                                            .font(.footnote)
//                                        Text("\(100)%")//TODO
//                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 20)
                                    .foregroundColor(Color.blue)
                                    
                                }
                            }
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        TextField("50%", text: $updatedSatisfaction)
                            .keyboardType(.asciiCapableNumberPad)
                            .frame(width: 50, height: 40, alignment: .center)
                            .background(Color(UIColor.systemBackground))
                            .multilineTextAlignment(.center)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding()
                }
                .frame(width: 200, height: 200)
                .animation(.easeInOut)
                .offset(y: isSatisfiedPresnted ? 0 : screen.height)
                Spacer()
            }
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
