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
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
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

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
        .shadow(color: Color(#colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.09411764706, alpha: 1)).opacity(0.09), radius: 1, x: 0, y: 0)
        .shadow(color: Color(#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1725490196, alpha: 1)).opacity(0.09), radius: 2, x: 0, y: 0.5)
    }
}

struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .black

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
    
    func shadow() -> some View {
        self.modifier(Shadow())
    }

}
