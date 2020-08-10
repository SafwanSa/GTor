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
    var isLogout: Bool = false
    
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
            .background(Color(isLogout ? "Level 3" : "Level 0"))
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
                    SettingsRowButtonView(text: NSLocalizedString("Tags Settings", comment: ""), icon: "tag", isHavingDestination: true)
                }
                VStack {
                    Button(action: {}) {
                        SettingsRowButtonView(text: NSLocalizedString("Rate The App", comment: ""), icon: "star", isHavingDestination: false)
                    }
                    
                    Button(action: {}) {
                        SettingsRowButtonView(text: NSLocalizedString("Share The App", comment: ""), icon: "square.and.arrow.up", isHavingDestination: false)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        SettingsRowButtonView(text: NSLocalizedString("About GTor", comment: ""), icon: "info.circle", isHavingDestination: true)
                    }
                }
                VStack {
                    Button(action: self.authService.signOutUser) {
                        SettingsRowButtonView(text: NSLocalizedString("Logout", comment: ""), icon: "arrow.down.left.circle.fill", isHavingDestination: false, isLogout: true)
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
