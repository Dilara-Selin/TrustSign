//
//  TrustSignApp.swift
//  TrustSign
//
//  Created by Dilara Selin SALCI on 12.12.2025.
//
//

import SwiftUI
internal import CoreData

@main
struct TrustSignApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
            WindowGroup {
                SplashView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
}
