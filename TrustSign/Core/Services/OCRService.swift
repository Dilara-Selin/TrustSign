//
//  OCRService.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import Foundation
import Vision
import UIKit

class OCRService {
    static let shared = OCRService()
    
    private init() {}
    
    func recognizeText(from image: UIImage) async -> String? {
        guard let cgImage = image.cgImage else { return nil }
        
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let fullText = recognizedStrings.joined(separator: "\n")
                // Konsola yazdır (Debug)
                print("\n🚀 [OCR ÇIKTISI] 🚀\n\(fullText)\n🏁 [BİTİŞ] 🏁\n")
                
                continuation.resume(returning: fullText)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    func extractData(from text: String) -> (name: String, surname: String, birthDate: String) {
        let lines = text.components(separatedBy: "\n")
   
        if let mrzData = parseMRZ(lines: lines) {
            print("✅ Veri MRZ kodundan çekildi.")
            return mrzData
        }
        
       
        if text.contains("Фамилия") || text.contains("Отчество") {
            print("🇷🇺 Rusça Belge Algılandı")
            return parseRussian(lines: lines)
        }
        
   
        var name = ""
        var surname = ""
        var birthDate = ""
        
      
        var surname1 = ""
        var surname2 = ""
        
        for (i, line) in lines.enumerated() {
            let cleanLine = line.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
          
            if cleanLine.contains("prezvisko") {
                if i + 1 < lines.count { surname = lines[i + 1] }
            }
            if cleanLine.contains("meno") && !cleanLine.contains("zmeno") {
                if i + 1 < lines.count { name = lines[i + 1] }
            }
            if cleanLine.contains("dátum narodenia") || cleanLine.contains("datum narodenia") {
                if i + 1 < lines.count { birthDate = lines[i + 1] }
            }

          
            if cleanLine.contains("презиме") || cleanLine.contains("prezime") {
                if i + 1 < lines.count { surname = lines[i + 1] }
            }
            if (cleanLine.contains("име") || cleanLine.contains("ime")) && !cleanLine.contains("prezime") && !cleanLine.contains("презиме") {
                if i + 1 < lines.count { name = lines[i + 1] }
            }
            if cleanLine.contains("датум") || cleanLine.contains("datum") {
                if i + 1 < lines.count { birthDate = lines[i + 1] }
            }
            
            
            if cleanLine.contains("uzvārds") || cleanLine.contains("uzvards") {
                if i + 1 < lines.count { surname = lines[i + 1] }
            }
            if cleanLine.contains("vārds") || cleanLine.contains("vards") {
                if i + 1 < lines.count { name = lines[i + 1] }
            }
            if cleanLine.contains("dzimšanas datums") || cleanLine.contains("dzimsanas datums") {
                if i + 1 < lines.count { birthDate = lines[i + 1] }
            }
            
     
            if cleanLine.contains("sukunimi") || cleanLine.contains("efternamn") {
                if i + 1 < lines.count { surname = lines[i + 1] }
            }
            if cleanLine.contains("etunimet") || cleanLine.contains("förnamn") || cleanLine.contains("exunimet") {
                if i + 1 < lines.count { name = lines[i + 1] }
            }
            if cleanLine.contains("syntymaaika") || cleanLine.contains("födelsedatum") {
                let maxSearch = min(i + 6, lines.count)
                for j in (i + 1)..<maxSearch {
                    let potentialDate = lines[j].trimmingCharacters(in: .whitespacesAndNewlines)
                    if potentialDate.contains(".") && potentialDate.count >= 10 {
                         let parts = potentialDate.components(separatedBy: " ")
                         if let datePart = parts.first, datePart.contains(".") {
                             birthDate = datePart
                             break
                         }
                    }
                }
            }
            
            if cleanLine.contains("primer apellido") {
                if i + 1 < lines.count { surname1 = lines[i + 1] }
            }
            if cleanLine.contains("segundo apellido") {
                if i + 1 < lines.count { surname2 = lines[i + 1] }
            }
            if cleanLine == "nombre" {
                if i + 1 < lines.count { name = lines[i + 1] }
            }
            if cleanLine.contains("fecha de nacimiento") {
                if i + 1 < lines.count { birthDate = lines[i + 1] }
            }
            
      
            if surname.isEmpty {
                if cleanLine.contains("surname") || cleanLine.contains("soyad") || cleanLine.contains("mbiemri") || cleanLine.contains("perekonnanim") {
                    if i + 1 < lines.count { surname = lines[i + 1] }
                }
            }
            if name.isEmpty {
                if cleanLine.contains("given name") || cleanLine.contains("name") && !cleanLine.contains("sur") || cleanLine.contains("adı") || cleanLine.contains("emri") {
                    if i + 1 < lines.count { name = lines[i + 1] }
                }
            }
            if birthDate.isEmpty {
                if cleanLine.contains("date of birth") || cleanLine.contains("doğum") || cleanLine.contains("datelindia") || cleanLine.contains("doğulduğu") {
                    if i + 1 < lines.count { birthDate = lines[i + 1] }
                }
            }
        }
        
 
        if !surname1.isEmpty {
            surname = "\(surname1) \(surname2)".trimmingCharacters(in: .whitespaces)
        }
        
        if birthDate.contains(" ") && !birthDate.contains(".") {
            birthDate = birthDate.replacingOccurrences(of: " ", with: ".")
        }
        if birthDate.count > 10 && birthDate.contains(".") {
             let parts = birthDate.split(separator: " ")
             if let firstPart = parts.first, firstPart.count == 10 {
                 birthDate = String(firstPart)
             }
        }
        if birthDate.hasSuffix(".") {
            birthDate = String(birthDate.dropLast())
        }
        
        return (name, surname, birthDate)
    }
    

    private func parseRussian(lines: [String]) -> (String, String, String) {
        var name = ""
        var surname = ""
        var birthDate = ""
        let reservedWords = ["ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", "РОЖДЕНИЯ", "МЕСТО", "МУЖ", "ЖЕН", "ГОРОД", "ОБЛАСТЬ", "КРАЙ", "РЕСПУБЛИКА", "ПАСПОРТ", "ВЫДАН", "ДАТА", "КОД", "ПОДРАЗДЕЛЕНИЯ", "ГОР", "УФМС", "РОССИИ"]
        var foundValues: [String] = []
        
        for line in lines {
            let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let upperLine = cleanLine.uppercased()
            if birthDate.isEmpty {
                if let range = cleanLine.range(of: "\\d{2}\\.\\d{2}\\.\\d{4}", options: .regularExpression) {
                    birthDate = String(cleanLine[range])
                    continue
                }
            }
            let hasCyrillic = cleanLine.range(of: "\\p{Cyrillic}", options: .regularExpression) != nil
            let isAllUpper = (cleanLine == upperLine) && cleanLine.count > 2
            let hasNumbers = cleanLine.range(of: "\\d", options: .regularExpression) != nil
            
            if hasCyrillic && isAllUpper && !hasNumbers {
                let isReserved = reservedWords.contains { upperLine.contains($0) }
                if !isReserved {
                    foundValues.append(cleanLine)
                }
            }
        }
        if foundValues.count > 0 { surname = foundValues[0] }
        if foundValues.count > 1 { name = foundValues[1] }
        return (name, surname, birthDate)
    }
    

    private func parseMRZ(lines: [String]) -> (String, String, String)? {
        let mrzLines = lines.filter { line in
            let l = line.uppercased().replacingOccurrences(of: " ", with: "")
            // DÜZELTME: Satır P, I, C, A ile başlayabilir VEYA Rakamla başlayabilir (1969... gibi)
            let startsWithValidChar = l.starts(with: "C") || l.starts(with: "P") || l.starts(with: "I") || l.starts(with: "A")
            let startsWithNumber = l.first?.isNumber == true
            
            return l.count > 20 && (l.contains("<<") || startsWithValidChar || startsWithNumber)
        }
        
        guard mrzLines.count >= 2 else { return nil }
        
      
        guard let nameLine = mrzLines.first(where: { $0.contains("<<") }) else { return nil }
        
        var dateLine = ""
        
        if let idx = mrzLines.firstIndex(of: nameLine), idx + 1 < mrzLines.count {
            dateLine = mrzLines[idx + 1].uppercased().replacingOccurrences(of: " ", with: "")
        } else {
       
            if let digitLine = mrzLines.first(where: { $0.first?.isNumber == true && $0 != nameLine }) {
                dateLine = digitLine.uppercased().replacingOccurrences(of: " ", with: "")
            }
        }
        
        guard !dateLine.isEmpty else { return nil }
        
        var name = ""
        var surname = ""
        var birthDate = ""
        
        let cleanNameLine = nameLine.uppercased().replacingOccurrences(of: " ", with: "")
        if cleanNameLine.count > 5 {
            let nameSection = String(cleanNameLine.dropFirst(5))
            let parts = nameSection.components(separatedBy: "<<")
            if parts.count >= 2 {
                surname = parts[0].replacingOccurrences(of: "<", with: "")
                name = parts[1].replacingOccurrences(of: "<", with: "")
            }
        }
        
        if dateLine.count > 20 {

            let dateStartIndex = dateLine.index(dateLine.startIndex, offsetBy: 13)
            let dateEndIndex = dateLine.index(dateStartIndex, offsetBy: 6)
            
            if dateEndIndex <= dateLine.endIndex {
                let dateString = String(dateLine[dateStartIndex..<dateEndIndex])
                if dateString.count == 6, Int(dateString) != nil {
                    let yy = String(dateString.prefix(2))
                    let mm = String(dateString.dropFirst(2).prefix(2))
                    let dd = String(dateString.suffix(2))
                    let prefix = (Int(yy) ?? 0) > 50 ? "19" : "20"
                    birthDate = "\(dd).\(mm).\(prefix)\(yy)"
                }
            }
        }
        return (name, surname, birthDate)
    }
}
