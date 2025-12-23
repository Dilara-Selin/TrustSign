//
//  BlockchainService.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 14.12.2025.
//
 


import Foundation
import web3swift
import BigInt
import Web3Core


enum ValidationStatus: Int {
    case unknown = 0
    case fake = 1
    case real = 2
}

class BlockchainService {
    static let shared = BlockchainService()
    
    private var web3: Web3?
    private var keystore: EthereumKeystoreV3?
    private var isSetupDone = false
    
    private init() { }
    
   
    private func ensureConnection() async {
        if isSetupDone && web3 != nil && keystore != nil { return }
        
        print("Blockchain: Bağlantı kontrol ediliyor...")
        
        do {
            guard let url = URL(string: Secrets.rpcURL) else { return }
            self.web3 = try await Web3.new(url)
            
        
            let keyString = Secrets.privateKey.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "0x", with: "")
            
            if !keyString.isEmpty, let data = Data.fromHex(keyString) {
            
                self.keystore = try EthereumKeystoreV3(privateKey: data, password: "")
                print("✅ Blockchain: Cüzdan Hazır! Adres: \(self.keystore?.addresses?.first?.address ?? "?")")
                isSetupDone = true
            } else {
                print("⚠️ Blockchain: Private Key hatalı.")
            }
        } catch {
            print("❌ Blockchain Kurulum Hatası: \(error)")
        }
    }
    

    func checkStatus(hash: String) async -> ValidationStatus {
        await ensureConnection()
        
        guard let web3 = web3, let contractAddr = EthereumAddress(Secrets.contractAddress) else { return .unknown }
        
        do {
         
            let readABI = """
            [{"inputs":[{"internalType":"string","name":"_documentId","type":"string"}],"name":"checkStatus","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"}]
            """
            
            guard let contract = web3.contract(readABI, at: contractAddr, abiVersion: 2) else { return .unknown }
            
            let readOp = contract.createReadOperation("checkStatus", parameters: [hash])!
            let result = try await readOp.callContractMethod()
            
            if let statusDict = result["0"], let statusBigUInt = statusDict as? BigUInt {
                return ValidationStatus(rawValue: Int(statusBigUInt)) ?? .unknown
            }
            return .unknown
            
        } catch {
            return .unknown
        }
    }
    
  
           func registerDocument(hash: String, status: ValidationStatus) async -> String? {
               await ensureConnection()
               
               guard let web3 = web3, let keystore = keystore else {
                   print("Hata: Cüzdan hazır değil.")
                   return nil
               }
               
               guard let contractAddr = EthereumAddress(Secrets.contractAddress) else {
                   print("Hata: Kontrat adresi hatalı.")
                   return nil
               }
               
               do {
                   let manager = KeystoreManager([keystore])
                   web3.addKeystoreManager(manager)
                   
         
                   let writeABI = """
                   [{"inputs":[{"internalType":"string","name":"_documentId","type":"string"},{"internalType":"uint8","name":"_label","type":"uint8"}],"name":"registerLabel","outputs":[],"stateMutability":"nonpayable","type":"function"}]
                   """
                   
                   guard let contract = web3.contract(writeABI, at: contractAddr, abiVersion: 2) else {
                       print("Contract tanımlanamadı")
                       return nil
                   }
                   
                   print("Blockchain: İşlem hazırlanıyor (Hash: \(hash.prefix(6))...)")
                   
                   let parameters: [Any] = [hash, BigUInt(status.rawValue)]
                   
                 
                   let writeOp = contract.createWriteOperation("registerLabel", parameters: parameters)!
                   
                  
                   writeOp.transaction.chainID = BigUInt(11155111)
                   
                   let hardcodedPrice = BigUInt(50_000_000_000)
                   
                   
                   writeOp.transaction.gasPrice = hardcodedPrice
                   writeOp.transaction.maxFeePerGas = nil
                   writeOp.transaction.maxPriorityFeePerGas = nil
                   
               
                   writeOp.transaction.gasLimit = BigUInt(300000)
                   
                   guard let myAddress = keystore.addresses?.first else { return nil }
                   writeOp.transaction.from = myAddress
                   
          
                   let result = try await writeOp.writeToChain(password: "", policies: .auto)
                   
                   print("🚀 Blockchain İşlemi Gönderildi! Tx: \(result.hash)")
                   return result.hash
                   
               } catch {
                   print("❌ Blockchain Yazma Hatası: \(error)")
                   return nil
               }
           }
     }

