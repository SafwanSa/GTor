//
//  SettingsView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct SettingsRowButtonView: View {
    var text: String
    var icon: String
    var isHavingDestination: Bool
    
    var body: some View {
        VStack(spacing: 27.0) {
            HStack {
                Image(systemName: icon)
                Text(text)
                Spacer()
                Image(systemName: "chevron.right").opacity(isHavingDestination ? 1 : 0)
            }
            .padding(.vertical)
            .padding(.horizontal, 22)
            .background(Color(text == "Logout" ? "Level 3" : "Level 0"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .elevation()
            .foregroundColor(Color("Primary"))
        }
        .foregroundColor(Color("Primary"))
    }
}

struct SettingsView: View {
    @ObservedObject var authService = AuthService.shared

    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 40) {
                NavigationLink(destination: CategoryEditorView()) {
                    SettingsRowButtonView(text: "Tags Settings", icon: "tag", isHavingDestination: true)
                }
                VStack {
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Rate The App", icon: "star", isHavingDestination: false)
                    }
                    
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Share The App", icon: "square.and.arrow.up", isHavingDestination: false)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        SettingsRowButtonView(text: "About GTor", icon: "info.circle", isHavingDestination: true)
                    }
                }
                VStack {
                    Button(action: self.authService.signOutUser) {
                        SettingsRowButtonView(text: "Logout", icon: "arrow.down.left.circle.fill", isHavingDestination: false)
                    }
//                    Button(action: {}) {
//                        SettingsRowButtonView(text: "Delete Account", isHavingDestination: false)
//                    }
                }
            }.padding(.horizontal)
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
