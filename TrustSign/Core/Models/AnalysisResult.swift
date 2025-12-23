//
//  AnalysisResult.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import UIKit

enum DocumentType: String {
    case idCard = "Kimlik Kartı"
    case passport = "Pasaport"
    case unknown = "Bilinmiyor"
}

struct AnalysisResult: Identifiable {
    let id = UUID()
    
    let documentType: DocumentType
    let isReal: Bool
    let confidence: Double
    
 
    let extractedName: String
    let extractedSurname: String
    let extractedBirthDate: String
    

    let rawText: String
    
    let image: UIImage
}
