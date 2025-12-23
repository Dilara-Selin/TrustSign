//
//  HistoryView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI
internal import CoreData

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @FetchRequest(
        entity: ScanResultEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ScanResultEntity.date, ascending: false)]
    ) var scanResults: FetchedResults<ScanResultEntity>
    
    var body: some View {
        NavigationStack {
            ZStack {
              
                AppTheme.mainGradient.ignoresSafeArea()
                
                if scanResults.isEmpty {
                  
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Text("Henüz bir tarama geçmişi yok.")
                            .foregroundColor(.white.opacity(0.6))
                    }
                } else {
                 
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(scanResults) { scan in
                                NavigationLink(destination: HistoryDetailView(scan: scan)) {
                                    HistoryCardView(scan: scan)
                                }
                            }
                           
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationTitle("Geçmiş Taramalar")
            .navigationBarTitleDisplayMode(.inline)
           
            .toolbarBackground(AppTheme.primary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.accent)
                }
            }
        }
    }
}


struct HistoryCardView: View {
    let scan: ScanResultEntity
    
    var body: some View {
        HStack(spacing: 15) {
     
            if let data = scan.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.3))
                    )
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scan.fullName ?? "Bilinmiyor")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(scan.date?.formatted(date: .abbreviated, time: .shortened) ?? "")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
           
            VStack {
                Image(systemName: scan.isReal ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundColor(scan.isReal ? .green : .red)
                
                Text(scan.isReal ? "Güvenli" : "Riskli")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(scan.isReal ? .green : .red)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08)) // Cam Efekti
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
