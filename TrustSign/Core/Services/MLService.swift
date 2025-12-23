//
//  MLService.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import CoreML
import Vision
import UIKit

class MLService {
    static let shared = MLService()
    

    private var model: VNCoreMLModel?
    
    init() {
        do {
          
            let config = MLModelConfiguration()
            let wrapper = try TrustSignModel(configuration: config)
            model = try VNCoreMLModel(for: wrapper.model)
        } catch {
            print("Model yüklenemedi: \(error)")
        }
    }
    

    func predict(image: UIImage, completion: @escaping (Bool, Double) -> Void) {
        guard let model = model, let ciImage = CIImage(image: image) else {
            print("Model veya Resim hatası")
            completion(false, 0.0)
            return
        }
        

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(false, 0.0)
                return
            }
            
            let isReal = (topResult.identifier.lowercased() == "real")
            let confidence = Double(topResult.confidence)
            
            completion(isReal, confidence)
        }
    
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Analiz hatası: \(error)")
                completion(false, 0.0)
            }
        }
    }
}
