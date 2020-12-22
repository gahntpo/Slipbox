//
//  SlipboxPadApp.swift
//  SlipboxPad
//
//  Created by Karin Prater on 02.12.20.
//

import SwiftUI

@main
struct SlipboxPadApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(NavigationStateManager())

        }
    }
}
