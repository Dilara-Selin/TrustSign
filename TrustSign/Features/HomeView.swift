//
//  HomeView.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
          
                AppTheme.mainGradient.ignoresSafeArea()
                
             
                Circle()
                    .fill(AppTheme.accent.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .offset(x: -150, y: -350)
                    .blur(radius: 50)
                
                VStack(spacing: 0) {
                    
                 
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hoş Geldiniz")
                                .font(.caption)
                                .foregroundColor(AppTheme.accent)
                                .bold()
                            Text("TrustSign")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                    
                        Button(action: { showHistory = true }) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(.white.opacity(0.15))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                
                    VStack {
                        Spacer()
                        
                        if let image = viewModel.scannedImage {
                         
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 8)
                              
                                .overlay(
                                    GeometryReader { geometry in
                                        if viewModel.isAnalyzing {
                                            ZStack {
                                        
                                                Color.black.opacity(0.4)
                                                    .cornerRadius(16)
                                                
                                              
                                                ScanningAnimationView(height: geometry.size.height)
                                            }
                                        }
                                    }
                                )
                              
                                .frame(maxHeight: 450)
                                .padding(.horizontal, 25)
                            
                        } else {
                           
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                    .foregroundColor(.white.opacity(0.3))
                                    .frame(height: 350)
                                
                                VStack(spacing: 20) {
                                    Image(systemName: "viewfinder")
                                        .font(.system(size: 70))
                                        .foregroundColor(AppTheme.accent)
                                    
                                    Text("Belge Tara veya Yükle")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text("Blockchain üzerinde doğrulamak için\nkimlik kartınızı çerçeveye alın.")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 40)
                                }
                            }
                            .padding(.horizontal, 25)
                        }
                        
                        Spacer()
                        
                
                        VStack(spacing: 15) {
                            if viewModel.scannedImage != nil && !viewModel.isAnalyzing {
                        
                                Button(action: viewModel.startAnalysis) {
                                    HStack {
                                        Text("Doğrulamayı Başlat")
                                        Image(systemName: "arrow.right")
                                    }
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.accent)
                                    .cornerRadius(18)
                                    .shadow(color: AppTheme.accent.opacity(0.4), radius: 10, y: 5)
                                }
                            } else {
                           
                                Button(action: { viewModel.showScanner = true }) {
                                    HStack {
                                        Image(systemName: "camera.fill")
                                        Text("Belge Tara")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.white.opacity(0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 40)
                    }
                }
            }
                        .sheet(isPresented: $viewModel.showScanner) {
                            DocumentScannerView(scannedImage: $viewModel.scannedImage)
                                .ignoresSafeArea()
                        }
                        
                     
                        .sheet(item: $viewModel.analysisResult, onDismiss: {
                          
                            viewModel.resetApp()
                        }) { result in
                            ResultView(result: result)
                        }
                        
                
                        .sheet(isPresented: $showHistory) {
                            HistoryView()
                        }
            
              

                        .sheet(item: $viewModel.analysisResult, onDismiss: {
                            viewModel.resetApp()
                        }) { result in
                            ResultView(result: result)
                        }        }
    }
}

#Preview {
    HomeView()
}
