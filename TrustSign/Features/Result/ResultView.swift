//
//  ResultView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI

struct ResultView: View {
    let result: AnalysisResult
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
         
                AppTheme.mainGradient.ignoresSafeArea()
                
             
                Circle()
                    .fill(result.isReal ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .offset(x: 0, y: -300)
                    .blur(radius: 80)
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                    
                        VStack(spacing: 15) {
                            ZStack {
                             
                                Circle()
                                    .stroke(result.isReal ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 20)
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: result.isReal ? "checkmark.shield.fill" : "xmark.shield.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(result.isReal ? .green : .red)
                                    .shadow(color: (result.isReal ? Color.green : Color.red).opacity(0.6), radius: 15)
                            }
                            
                            VStack(spacing: 5) {
                                Text(result.isReal ? "DOĞRULANMIŞ BELGE" : "SAHTE / GEÇERSİZ")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(result.isReal ? "Blockchain ve AI tarafından onaylandı." : "Güvenlik testlerinden geçemedi.")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 20)
                        
               
                        Image(uiImage: result.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(result.isReal ? Color.green.opacity(0.6) : Color.red.opacity(0.6), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        
                       
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "doc.text.viewfinder")
                                    .foregroundColor(AppTheme.accent)
                                Text("KİMLİK VERİLERİ")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(AppTheme.accent)
                                    .tracking(1.5)
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            InfoRow(icon: "person.fill", title: "Ad", value: result.extractedName)
                            InfoRow(icon: "person.fill.viewfinder", title: "Soyad", value: result.extractedSurname)
                            InfoRow(icon: "calendar", title: "Doğum Tarihi", value: result.extractedBirthDate)
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            InfoRow(icon: "doc.text.fill", title: "Belge Tipi", value: result.documentType == .passport ? "Pasaport" : "Kimlik Kartı")
                            
                            HStack {
                                Image(systemName: "cpu")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 25)
                                Text("Güven Skoru")
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Text(String(format: "%%% .1f", result.confidence * 100))
                                    .bold()
                                    .foregroundColor(result.confidence > 0.8 ? .green : .orange)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.08)) // Cam Efekti
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                        
                      
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Tamamla & Çık")
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.accent) // Altın Sarısı
                                .cornerRadius(16)
                                .shadow(color: AppTheme.accent.opacity(0.4), radius: 10, y: 0)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Analiz Sonucu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppTheme.primary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 25)
            
            Text(title)
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text(value.isEmpty ? "Bulunamadı" : value)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}
