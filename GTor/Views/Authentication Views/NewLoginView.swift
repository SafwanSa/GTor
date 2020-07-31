//
//  NewLoginView.swift
//  GTor
//
//  Created by Safwan Saigh on 30/07/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct NewLoginView: View {
    @State var value = CGSize.zero
    @State var isStarted = false
    @State var isShowingSignup = true
    
    var body: some View {
        ZStack {
            HStack(spacing: 0.0) {
                Color("Button")
                Color("Level 3")
            }
            .offset(x: isShowingSignup ? screen.width/2 : -screen.width/2)
            .animation(.linear)
            
            VStack {
                Color("Level 0")
                    .clipShape(Circle())
                    .frame(width: screen.width*2)
                Spacer()
            }
            .elevation()
            .offset(y: isStarted ? screen.height/5 : screen.height/2)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            
            
            Image("circle-shape\(isShowingSignup ? "-blue" : "")")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 300, height: 250)
                .offset(x: isShowingSignup ? 10 : screen.width/2, y: -screen.height/2.5)
                .opacity(isShowingSignup ? 0 : 1)
                .rotationEffect(Angle(degrees: isShowingSignup ? -50 : 50))
                .animation(Animation.easeInOut.speed(0.6))
            
            
            HStack(spacing: 20.0) {
                Image("right-side-shape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                    .scaleEffect(isStarted ? 1.5 : 1)
                
                Text("GTor")
                    .font(.system(size: 50))
                    .opacity(isStarted ? 0 : 1)
                    .foregroundColor(Color("Level 0"))
                
                Image("left-side-shape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                    .scaleEffect(isStarted ? 1.5 : 1)
            }
            .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
            .offset(y: isStarted ? -screen.height/3 : -100)
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.2))
            
            HStack(spacing: 200) {
                Text("Sign Up")
                .rotationEffect(Angle(degrees: -20))
                    .offset(x: -10)
                    .foregroundColor(Color(isShowingSignup ? "Level 0" : "Secondry"))

                
                Text("Sign In")
                .rotationEffect(Angle(degrees: 20))
                 .offset(x: 7)
                    .foregroundColor(Color(isShowingSignup ? "Secondry" : "Level 0"))
                
            }
            .font(.system(size: 20, weight: .bold))
            .offset(y: -screen.height/3.7)
            .opacity(isStarted ? 1 : 0)
            .animation(.easeInOut)
            VStack {
                HStack(spacing: 0.0){
                    Button(action: {
                        if self.isStarted {
                            self.isShowingSignup = true
                        }
                    }) {
                        Color.clear
                    }
                    
                    Button(action: {
                        if self.isStarted {
                            self.isShowingSignup = false
                        }
                    }) {
                        Color.clear
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(height: screen.height/4 + 40)
                Spacer()
            }
            
            VStack {
                Text("Login")
                    .font(.system(size: 24))
                    .foregroundColor(Color("Primary"))
                    .frame(width: 120)
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(Color("Level 0"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
                    .offset(y: isStarted ? screen.height/5.3 : screen.height)
                    .animation(.spring())
                Spacer()
                Color("Secondry").opacity(0.2)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .shadow(color: Color("Primary").opacity(0.12), radius: 10, x: 0, y: 7)
                    .offset(y: -screen.height/3.5)
                    .opacity(isStarted ? 0 : 1)
                VStack {
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("Swipe Up To Start")
                }
                .foregroundColor(Color("Primary"))
                .opacity(isStarted ? 0 : 1)
                .offset(y: value.height - 30)
                .gesture(DragGesture().onChanged({ (value) in
                    self.value = value.translation
                    if value.translation.height < -screen.height/3 + 40 {
                        self.isStarted = true
                        
                    }else if value.translation.height > 0 {
                        self.value = .zero
                    }
                })
                    .onEnded({ (value) in
                        if value.translation.height > -screen.height/3 {
                            self.value = CGSize.zero
                        }
                    }))
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            }
            
            VStack {
                Spacer()
                if isStarted{
                    SignUpView(isNewUser: isShowingSignup, isShowingLogin: .constant(true))
                    .padding(.horizontal, 200)
                    .padding(.vertical, 20)
                    .padding(.bottom, 200)
                }
            }
            .offset(y: screen.height < 800 ? screen.height/9 : 0)
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

