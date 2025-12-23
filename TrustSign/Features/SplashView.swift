//
//  SplashView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 15.12.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            ZStack {
                AppTheme.primary.ignoresSafeArea()
                
                VStack {
                   
                    VStack(spacing: 20) {
                        Image(systemName: "shield.checkerboard") 
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.accent)
                        
                        Text("TrustSign")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                }
            }
            .onAppear {
             
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
