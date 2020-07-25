//
//  TextEditorView.swift
//  GTor
//
//  Created by Safwan Saigh on 26/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {
    @Environment(\.presentationMode) private var presentationMode
    var title: String
    @Binding var text: String
    @State var textCopy = ""
    var isShowingDone: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NewCardView(content: AnyView(
                    HStack {
                        TextField(textCopy, text: $textCopy)
                    }
                ))
                Spacer()
            }
            .padding()
            .navigationBarTitle("\(title)", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { self.text = self.textCopy ; self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Done")
                        .font(.callout)
                        .foregroundColor(Color("Button"))
                }
                .opacity(isShowingDone ? 1 : 0)
            )
                .onAppear {
                    self.textCopy = self.text
            }
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(title: "Edit Title", text: .constant(""))
    }
}
