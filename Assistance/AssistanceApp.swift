//
//  AssistanceApp.swift
//  Assistance
//
//  Created by David Dyck on 10/03/25.
//

import SwiftUI
import SwiftData

@main
struct AssistanceApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Entry.self]) // Defines the database schema
        let container = try! ModelContainer(for: schema) // Creates a persistent storage
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer) // 🔹 Ensures persistent storage
        }
    }
}
