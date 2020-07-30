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
    var isHavingDestination: Bool
    
    var body: some View {
        VStack(spacing: 27.0) {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "chevron.right").opacity(isHavingDestination ? 1 : 0)
            }
            .padding(.vertical)
            .padding(.horizontal, 22)
            .background(Color(text == "Delete Account" ? "Level 3" : "Level 0"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .elevation()
            .foregroundColor(Color("Primary"))
        }
        .foregroundColor(Color("Primary"))
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 40) {
                NavigationLink(destination: CategoryEditorView()) {
                    SettingsRowButtonView(text: "Tags Settings", isHavingDestination: true)
                }
                VStack {
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Rate The App", isHavingDestination: false)
                    }
                    
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Share The App", isHavingDestination: false)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        SettingsRowButtonView(text: "About GTor", isHavingDestination: true)
                    }
                }
                VStack {
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Logout", isHavingDestination: false)
                    }
                    Button(action: {}) {
                        SettingsRowButtonView(text: "Delete Account", isHavingDestination: false)
                    }
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
