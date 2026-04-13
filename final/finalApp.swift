//
//  finalApp.swift
//  final
//
//  Created by Tech on 2026-04-07.
//

import SwiftUI

@main
struct finalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
