//
//  WelcomeView.swift
//  GTor
//
//  Created by Safwan Saigh on 31/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct Mockup: Identifiable {
    var id = UUID()
    var photo: String
    var title: String
    var des: String
}
let mockups: [Mockup] = [
    .init(photo: "animated-task1", title: "Organize your life", des: "Track your goals"),
    .init(photo: "task2-shape", title: "Boost your productivity", des: "Track your TODOs"),
    .init(photo: "task3-shape", title: "Organize your life", des: "Track your goals")
]

struct WelcomeView: View {
    @State var currentMockupIndex: Int = -1
    @State var isFinished = false
    @State var isShowingLoginView = false
    
    func mult(index: Int) -> CGFloat {
        return CGFloat(index) * -screen.width
    }
    var body: some View {
        VStack {
            Group {
                if isShowingLoginView {
                    LaunchView()
                }else {
                    ZStack {
                        HStack {
                            HStack {
                                ForEach(mockups.indices, id: \.self) { index in
                                    MockupSectionView(currentMockupIndex: index)
                                }
                            }
                            .offset(x: mult(index: currentMockupIndex))
                        }
                        .animation(.spring())
                        VStack {
                            Spacer()
                            HStack {
                                if !isFinished {
                                    HStack(spacing: 2.0) {
                                        ForEach(-1 ..< mockups.count-1) { index in
                                            Color(index == self.currentMockupIndex ? "Button" : "Secondry")
                                                .frame(width: index == self.currentMockupIndex ? 30 : 7, height: 7)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                        }
                                    }
                                    Spacer()
                                }
                                
                                Button(action: {
                                    if self.isFinished { self.isShowingLoginView = true }
                                    if self.currentMockupIndex == mockups.count-2 { self.isFinished = true } else { self.currentMockupIndex+=1 }
                                }) {
                                    Text(isFinished ? "Get Started" : "Next")
                                    .font(.system(size: 18))
                                    .frame(width: isFinished ? 200 : 100)
                                    .padding()
                                    .background(Color("Button"))
                                    .foregroundColor(Color("Level 0"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow()
                                }
                            }
                            .padding(.horizontal, 24)
                            .animation(.spring())
                        }
                        .frame(width: screen.width)
                    }
                    .frame(width: screen.width)
                    .padding(.vertical)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                }
            }
        }


        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

struct MockupSectionView: View {
    var currentMockupIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 25.0) {
            if currentMockupIndex == 0 {
                LottieView(filename: mockups[currentMockupIndex].photo)
                    .frame(width: screen.width, height: screen.width)
                    .scaleEffect(1.6)
            }else {
                Image(mockups[currentMockupIndex].photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screen.width, height: screen.width)
                    .scaleEffect(1.3)
            }
            
            
            VStack(spacing: 15.0) {
                Text(mockups[currentMockupIndex].title)
                    .foregroundColor(Color("Primary"))
                .font(.system(size: 30))
                
                Text(mockups[currentMockupIndex].des)
                    .foregroundColor(Color.secondary)
                .font(.system(size: 27))
            }
            Spacer()
        }
    }
}
