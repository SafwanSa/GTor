//
//  ImportanceCard.swift
//  GTor
//
//  Created by Safwan Saigh on 18/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI


struct ImportanceCard: View {
    var goal: Goal
    @Binding var isEditingMode: Bool
    @State var updatedImportance = ""
    
    
    var body: some View {
        HStack {
            if isEditingMode && !self.goal.isDecomposed! {
                Text("Importance")
                Spacer()
                TextField("\("Very Important")", text: self.$updatedImportance)
                    .padding()
                    .foregroundColor(.primary)
            }else {
                Text("Importance")
                Spacer()
                Text("\(self.goal.importance?.description ?? "")")
                    .padding()
                    .foregroundColor(.primary)
            }
            
        }
        .font(.headline)
        .frame(width: screen.width - 60, height: 20)
        .padding(10)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(1), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(self.goal.importance?.opacity ?? 0)
                
        })
    }
}
