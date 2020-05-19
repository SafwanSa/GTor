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
            .frame(width: screen.width - 80, height: 30)
            .padding(10)
            .padding(.horizontal, 5)
            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.secondarySystemGroupedBackground).opacity(1), Color(UIColor.secondarySystemGroupedBackground)]), startPoint: .bottomLeading, endPoint: .topTrailing))
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
