//
//  AppTheme.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI

struct AppTheme {
   
    static let primary = Color(red: 0.05, green: 0.12, blue: 0.25)
    
   
    static let accent = Color(red: 1.0, green: 0.78, blue: 0.35)
    
  
    static let background = Color(red: 0.96, green: 0.97, blue: 0.99)
    

    static let success = Color(red: 0.10, green: 0.70, blue: 0.45)
    static let error = Color(red: 0.85, green: 0.30, blue: 0.30)
    
   
    static let mainGradient = LinearGradient(
        gradient: Gradient(colors: [primary, Color(red: 0.10, green: 0.20, blue: 0.40)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
