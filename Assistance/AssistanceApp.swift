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
        let schema = Schema([Entry.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer) // 🔹 Ensures persistence
        }
    }
}
