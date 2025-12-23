//
//  LogoGenerator.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 17.12.2025.
//

import SwiftUI

struct LogoGenerator: View {
    var body: some View {
        ZStack {
          
            Color(red: 0.05, green: 0.12, blue: 0.25)
                .ignoresSafeArea()
            
          
            ZStack {
            
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.78, blue: 0.35), // Amber
                                Color(red: 1.0, green: 0.60, blue: 0.20)  // Hafif Turuncu
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 30
                    )
                    .frame(width: 300, height: 300)
                    .shadow(color: Color(red: 1.0, green: 0.78, blue: 0.35).opacity(0.4), radius: 20)
                
             
                Image(systemName: "shield.checkerboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .foregroundColor(Color(red: 1.0, green: 0.78, blue: 0.35)) // Amber Rengi
                    .shadow(radius: 10)
            }
        }
        .frame(width: 500, height: 500)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LogoGenerator()
        .padding()
}
