//
//  ContentView.swift
//  Assistance
//
//  Created by David Dyck on 10/03/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]
    
    var body: some View {
        TabView {
            HomeView(entries: entries, checkIn: checkIn, checkOut: checkOut, deleteEntries: deleteEntries, isCurrentlyCheckedIn: isCurrentlyCheckedIn)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ExportView(entries: entries)
                .tabItem {
                    Label("Export", systemImage: "square.and.arrow.down.fill")
                }
        }
    }

    private func checkIn() {
        withAnimation {
            let newEntry = Entry(checkIn: Date())
            modelContext.insert(newEntry)
        }
    }

    private func checkOut() {
        withAnimation {
            if let lastUnfinishedEntry = entries.last(where: { $0.checkOut == nil }) {
                lastUnfinishedEntry.checkOut = Date()
            }
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(entries[index])
            }
        }
    }

    private func isCurrentlyCheckedIn() -> Bool {
        guard let lastEntry = entries.last else { return false }
        return lastEntry.checkOut == nil
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self)
}
