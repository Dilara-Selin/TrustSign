//
//  IDCardModel.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//


import Foundation

struct IDCardData: Identifiable {
    let id = UUID()
    var name: String = ""
    var surname: String = ""
    var birthDate: String = ""
    var city: String = ""
    var rawText: String = ""
}

class IDParser {
  
    static func parse(texts: [String]) -> IDCardData {
        var data = IDCardData()
        data.rawText = texts.joined(separator: "\n")
        
  
        
        for (index, text) in texts.enumerated() {
            let line = text.uppercased()
            
       
            if line.contains("AD") || line.contains("GIVEN NAME") {
       
                if index + 1 < texts.count {
                    data.name = texts[index + 1]
                }
            }
            
          
            if line.contains("SOYAD") || line.contains("SURNAME") {
                if index + 1 < texts.count {
                    data.surname = texts[index + 1]
                }
            }
            
         
            if line.contains(".") {
                if line.range(of: #"\d{2}\.\d{2}\.\d{4}"#, options: .regularExpression) != nil {
                    data.birthDate = line
                }
            }
            
  
            if line.contains("DOĞUM YERİ") || line.contains("PLACE OF BIRTH") {
                 let cleaned = line.replacingOccurrences(of: "DOĞUM YERİ", with: "")
                                   .replacingOccurrences(of: "PLACE OF BIRTH", with: "")
                                   .trimmingCharacters(in: .whitespacesAndNewlines)
                 if !cleaned.isEmpty {
                     data.city = cleaned
                 } else if index + 1 < texts.count {
                     data.city = texts[index + 1]
                 }
            }
        }
        
        return data
    }
}
