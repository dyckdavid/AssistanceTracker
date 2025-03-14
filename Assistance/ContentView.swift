//
//  ContentView.swift
//  Assistance
//
//  Created by David Dyck on 10/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(entries) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Check-In: \(entry.checkIn.formatted(date: .abbreviated, time: .shortened))")
                                if let checkOut = entry.checkOut {
                                    Text("Check-Out: \(checkOut.formatted(date: .abbreviated, time: .shortened))")
                                    Text("Total: \(calculateHours(entry: entry)) hours")
                                } else {
                                    Text("Currently Checked In")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteEntries)
                }
                
                Spacer()
                
                HStack {
                    Button("Check In") {
                        checkIn()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Check Out") {
                        checkOut()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isCurrentlyCheckedIn())
                }
                .padding()
            }
            .navigationTitle("Hour Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
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
        guard let lastEntry = entries.last else { return false } // Return false if no entries exist
        return lastEntry.checkOut == nil
    }

    private func calculateHours(entry: Entry) -> String {
        guard let checkOut = entry.checkOut else { return "0" }
        let duration = checkOut.timeIntervalSince(entry.checkIn) / 3600
        return String(format: "%.2f", duration)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}
