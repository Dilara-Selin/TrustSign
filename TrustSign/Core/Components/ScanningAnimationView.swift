//
//  ScanningAnimationView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI

struct ScanningAnimationView: View {
  let height: CGFloat
    
    @State private var isAtTop = true
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppTheme.accent.opacity(0),
                        AppTheme.accent,
                        AppTheme.accent.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 4)
            .shadow(color: AppTheme.accent, radius: 8)
            .offset(y: isAtTop ? -height/2 + 2 : height/2 - 2)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    isAtTop.toggle()
                }
            }
    }
}
