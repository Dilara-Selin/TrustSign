//
//  HomeViewModel.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import Foundation
import Combine
import SwiftUI
import Vision
import UIKit
internal import CoreData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var scannedImage: UIImage?
    @Published var isAnalyzing = false
    @Published var analysisResult: AnalysisResult?
    @Published var errorMessage: String?
    @Published var showScanner = false


    func resetApp() {
        self.scannedImage = nil
        self.analysisResult = nil
        self.isAnalyzing = false
        self.errorMessage = nil
    }


    func startAnalysis() {
        guard let image = scannedImage else { return }
        
        isAnalyzing = true
        errorMessage = nil
        
        Task {
            
            let recognizedText = await OCRService.shared.recognizeText(from: image) ?? ""
            
        
            let (mlIsReal, mlConfidence): (Bool, Double) = await withCheckedContinuation { continuation in
                MLService.shared.predict(image: image) { isReal, confidence in
                    continuation.resume(returning: (isReal, confidence))
                }
            }
            
         
            let extractedData = OCRService.shared.extractData(from: recognizedText)
            
            
            let fullTextUpper = recognizedText.uppercased()
            var type: DocumentType = .unknown
            if fullTextUpper.contains("PASSPORT") { type = .passport }
            else if fullTextUpper.contains("CUMHURİYETİ") || fullTextUpper.contains("IDENTITY") { type = .idCard }
            
          
            let imageHash = CryptoService.generateHash(from: image) ?? ""
            var txHash: String? = nil
            var finalIsReal = mlIsReal
            
            if !imageHash.isEmpty {
                print("Blockchain sorgusu: \(imageHash)")
                let status = await BlockchainService.shared.checkStatus(hash: imageHash)
                
                switch status {
                case .real:
                    finalIsReal = true
                case .fake:
                    finalIsReal = false
                case .unknown:
                  
                    let statusToSend: ValidationStatus = mlIsReal ? .real : .fake
                    txHash = await BlockchainService.shared.registerDocument(hash: imageHash, status: statusToSend)
                }
            }
            
          
            let finalResult = AnalysisResult(
                documentType: type,
                isReal: finalIsReal,
                confidence: mlConfidence,
                extractedName: extractedData.name,
                extractedSurname: extractedData.surname,
                extractedBirthDate: extractedData.birthDate,
                rawText: recognizedText,
                image: image             )
            
         
            self.analysisResult = finalResult
            self.isAnalyzing = false
            
 
            self.saveScan(result: finalResult, txHash: txHash, imageHash: imageHash)
        }
    }
    

    private func saveScan(result: AnalysisResult, txHash: String?, imageHash: String?) {
        let viewContext = PersistenceController.shared.container.viewContext
        let newScan = ScanResultEntity(context: viewContext)
        
        newScan.id = UUID()
        newScan.date = Date()
        newScan.isReal = result.isReal
        newScan.confidence = result.confidence
        newScan.documentType = result.documentType.rawValue
        
        if !result.extractedName.isEmpty || !result.extractedSurname.isEmpty {
            newScan.fullName = "\(result.extractedName) \(result.extractedSurname)"
        } else {
            newScan.fullName = "Bilinmeyen Kişi"
        }
        
        newScan.imageHash = imageHash
        newScan.txHash = txHash
        newScan.imageData = result.image.jpegData(compressionQuality: 0.8)
        
        try? viewContext.save()
    }
}
