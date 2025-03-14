//
//  HomeView.swift
//  Assistance
//
//  Created by David Dyck on 14/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let entries: [Entry]
    let checkIn: () -> Void
    let checkOut: () -> Void
    let deleteEntries: (IndexSet) -> Void
    let isCurrentlyCheckedIn: () -> Bool

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

    private func calculateHours(entry: Entry) -> String {
        guard let checkOut = entry.checkOut else { return "0" }
        let duration = checkOut.timeIntervalSince(entry.checkIn) / 3600
        return String(format: "%.2f", duration)
    }
}
