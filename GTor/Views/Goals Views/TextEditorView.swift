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
        if title == "Edit Satisfaction" {
            if Double(textCopy) == nil {
                return false
            }
        }
        return !textCopy.isEmpty && textCopy != text
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NewCardView(content: AnyView(
                    HStack {
                        TextField(text.isEmpty ? "Note (Optional)" : textCopy, text: $textCopy)
                            .keyboardType(title == "Edit Satisfaction" ? .asciiCapableNumberPad : .default)
                        
                        Button(action: { self.textCopy = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("Primary"))
                        }
                        .buttonStyle(PlainButtonStyle())
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
