//
//  ExportView.swift
//  Assistance
//
//  Created by David Dyck on 14/03/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import SwiftData

struct ExportView: View {
    let entries: [Entry]
    @State private var fileURL: URL?
    @State private var showShareSheet = false

    var body: some View {
        VStack {
            Text("Export Hours Worked")
                .font(.headline)
                .padding()

            Button(action: exportToExcel) {
                Label("Export to Excel", systemImage: "square.and.arrow.down.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if let fileURL = fileURL {
                ShareLink(item: fileURL, preview: SharePreview("Exported Hours.xlsx"))
            }
        }
    }

    private func exportToExcel() {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let fileName = "HoursWorked.xlsx"
        let filePath = tempDir.appendingPathComponent(fileName)

        var csvText = "Check-In,Check-Out,Total Hours\n"
        for entry in entries {
            let checkInStr = entry.checkIn.formatted(date: .abbreviated, time: .shortened)
            let checkOutStr = entry.checkOut?.formatted(date: .abbreviated, time: .shortened) ?? "Still Checked In"
            let totalHours = entry.checkOut != nil ? calculateHours(entry: entry) : "0"

            csvText += "\(checkInStr),\(checkOutStr),\(totalHours)\n"
        }

        do {
            try csvText.write(to: filePath, atomically: true, encoding: .utf8)
            fileURL = filePath
            showShareSheet = true
        } catch {
            print("Error writing file: \(error)")
        }
    }

    private func calculateHours(entry: Entry) -> String {
        guard let checkOut = entry.checkOut else { return "0" }
        let duration = checkOut.timeIntervalSince(entry.checkIn) / 3600
        return String(format: "%.2f", duration)
    }
}
