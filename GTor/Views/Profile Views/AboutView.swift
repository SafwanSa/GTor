//
//  AboutView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20.0) {
                    VStack(spacing: 5.0) {
                        Image("Trans-Gtor-New-Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .offset(y: +25)
                        Text("GTor")
                            .foregroundColor(Color("Primary"))
                            .font(.title)
                        Text(NSLocalizedString("Organize your life", comment: ""))
                            .font(.callout)
                            .foregroundColor(Color("Secondry"))
                        
                        Text("\(NSLocalizedString("Version", comment: "")) \(String(format: "%.1f", 1.0))")
                        .font(.caption)
                        .foregroundColor(Color("Button"))
                    }
                    

                    
                    VStack(spacing: 15.0) {
                        Text(NSLocalizedString("GTor is a goal tracker that will help you to organize your life by tracking your goals. You can see your goals' progress and categorize them by tags. ", comment: ""))
                        .lineLimit(4)


                        Text(NSLocalizedString("And to boost your productivity, GTor provides you with a dynamic todo list that will allow you to create tasks and linked them to your goals to satisfy them.", comment: ""))

                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Primary"))
                    .font(.system(size: 16, weight: .light, design: .serif))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .padding()
                    .background(Color("Level 0"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow()
                    
                    
                    Button(action: {/*go to twitter*/}) {
                        Text(NSLocalizedString("Follow us on Twitter", comment: ""))
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color("Button"))
                        .foregroundColor(Color("Level 0"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow()
                        
                    }
                    Spacer()
                }
                .padding()
                .offset(y: -25)
                .navigationBarTitle("\(NSLocalizedString("aboutGTor", comment: ""))")
            }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
