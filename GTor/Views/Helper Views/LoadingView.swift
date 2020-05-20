//
//  LoadingView.swift
//  GTor
//
//  Created by Safwan Saigh on 20/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            if isLoading {
                BlurView(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.7)
                
                LottieView(filename: "loading")
                    .frame(width: 200, height: 200)
            }
        }
        .transition(.opacity)
        .animation(.linear(duration: 0.5))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: .constant(true))
    }
}
