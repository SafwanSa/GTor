//
//  ModifiersViews.swift
//  GTor
//
//  Created by Safwan Saigh on 19/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI
import Combine

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

fileprivate var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
    Publishers.Merge(
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height },
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
    ).eraseToAnyPublisher()
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    fileprivate var defaultOffset: CGFloat = 0
    fileprivate var keyboardHeightModifier: CGFloat = 0
    
    var isKeyboardShown: Bool {
        return keyboardHeight != 0
    }
    
    func body(content: Content) -> some View {
        content
            .offset(y: isKeyboardShown ? -keyboardHeight + -keyboardHeightModifier : defaultOffset)
            .animation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0))
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

struct KeyboardAwareHeightModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State var viewMinY: CGFloat = 0
    @State var bottomSafeAreaHeight: CGFloat = 0
    
    var isKeyboardShown: Bool {
        return keyboardHeight != 0
    }
    
    func body(content: Content) -> some View {
        content
            .frame(height:
                isKeyboardShown
                    ? screen.height - keyboardHeight - viewMinY - 22
                    : screen.height - keyboardHeight - viewMinY - bottomSafeAreaHeight - 100 - 64
            )
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .frame(width: 1, height: 1)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.viewMinY = geo.frame(in: .global).minY
                                self.bottomSafeAreaHeight = geo.safeAreaInsets.bottom
                            }
                        }
                }
            )
    }
}

extension View {
    func keyboardAware(defaultOffset: CGFloat = 0, keyboardHeightModifier: CGFloat = 0) -> some View {
        self.modifier(KeyboardAwareModifier(defaultOffset: defaultOffset, keyboardHeightModifier: keyboardHeightModifier))
    }
    
    func heightKeyboardAware() -> some View {
        self.modifier(KeyboardAwareHeightModifier())
    }
}
