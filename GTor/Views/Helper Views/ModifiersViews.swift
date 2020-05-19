//
//  ModifiersViews.swift
//  GTor
//
//  Created by Safwan Saigh on 19/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct SmallCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: screen.width - 60, height: 20)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(1), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct EditAnimation: ViewModifier {
    var isSubGoalsListExpanded: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: self.isSubGoalsListExpanded ? 3 : 0)
            .scaleEffect(isSubGoalsListExpanded ? 0.9 : 1)
            .animation(.spring())
    }
}
