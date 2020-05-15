//
//  GoalsView.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct GoalsView: View {
    var body: some View {
        //        NavigationView {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    GoalCardView()
                }
            }
            .padding(.horizontal)
            .padding(.top, 160)
            .navigationBarTitle("My Goals")
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        //        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}

struct GoalCardView: View {
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                Color.black
                    .frame(width: 60, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .multilineTextAlignment(.leading)
                    .offset(x: -10, y: -25)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Get A+ in ICSS 233")
                        .font(.headline)
                    Text("I ics 233 is 4 credit")
                        .font(.subheadline)
                }
                .offset(y: -15)
                Spacer()
            }
            Spacer()
        }
        .frame(width: screen.width - 70, height: 120)
        .padding(.leading, 16)
        .padding(.vertical, 16)
        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
        .overlay(
            HStack {
                Spacer()
                Color.red
                    .frame(width: 10)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
        })
    }
}
