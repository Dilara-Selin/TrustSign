//
//  HistoryDetailView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI

struct HistoryDetailView: View {
    let scan: ScanResultEntity // CoreData'dan gelen kayıt
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
          
            AppTheme.mainGradient.ignoresSafeArea()
            

            Circle()
                .fill(AppTheme.accent.opacity(0.1))
                .frame(width: 400, height: 400)
                .offset(x: 100, y: -200)
                .blur(radius: 60)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                   
                    VStack(spacing: 10) {
                        Image(systemName: scan.isReal ? "checkmark.shield.fill" : "xmark.shield.fill")
                            .font(.system(size: 70))
                            .foregroundColor(scan.isReal ? .green : .red)
                            .shadow(color: (scan.isReal ? Color.green : Color.red).opacity(0.5), radius: 10)
                        
                        Text(scan.isReal ? "Güvenli Belge" : "Şüpheli Belge")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(scan.date?.formatted(date: .long, time: .shortened) ?? "-")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 20)
                    
             
                    if let data = scan.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(scan.isReal ? Color.green.opacity(0.5) : Color.red.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
       
                    VStack(alignment: .leading, spacing: 20) {
                        Text("KAYIT DETAYLARI")
                            .font(.caption)
                            .bold()
                            .foregroundColor(AppTheme.accent)
                            .tracking(1.5)
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        DetailRow(icon: "person.text.rectangle", title: "Ad Soyad", value: scan.fullName ?? "Bilinmiyor")
                        DetailRow(icon: "doc.text", title: "Belge Tipi", value: scan.documentType == "passport" ? "Pasaport" : "Kimlik Kartı")
                        DetailRow(icon: "link", title: "Blockchain Hash", value: formatHash(scan.imageHash))
                        DetailRow(icon: "network", title: "İşlem Kodu (Tx)", value: formatHash(scan.txHash))
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack {
                            Text("Güven Skoru")
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text(String(format: "%%% .1f", scan.confidence * 100))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08)) // Cam efekti
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationTitle("İşlem Detayı")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func formatHash(_ hash: String?) -> String {
        guard let h = hash, h.count > 10 else { return hash ?? "Yok" }
        return "\(h.prefix(6))...\(h.suffix(4))"
    }
}


struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                Text(value)
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}
