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
                        Text(NSLocalizedString("organizeYourLife", comment: ""))
                            .font(.callout)
                            .foregroundColor(Color("Secondry"))
                        
                        Text("\(NSLocalizedString("version", comment: "")) \(String(format: "%.1f", appVersion))")
                        .font(.caption)
                        .foregroundColor(Color("Button"))
                    }
                    

                    
                    VStack(spacing: 15.0) {
                        Text(NSLocalizedString("aboutGTorPara1", comment: ""))
                        .lineLimit(4)


                        Text(NSLocalizedString("aboutGTorPara2", comment: ""))

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
                        Text(NSLocalizedString("followUsOnTwitter", comment: ""))
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
