//
//  CryptoService.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 14.12.2025.
//

import CryptoKit
import UIKit

class CryptoService {
    

    static func generateHash(from image: UIImage) -> String? {

        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
     
        let digest = SHA256.hash(data: imageData)
        
        
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}
